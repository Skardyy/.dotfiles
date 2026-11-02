package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"strings"
	"sync"
	"syscall"

	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
)

type ifaceList []string

func (l *ifaceList) String() string     { return strings.Join(*l, ",") }
func (l *ifaceList) Set(v string) error { *l = append(*l, v); return nil }

func linkOffset(lt layers.LinkType) int {
	switch lt {
	case layers.LinkTypeEthernet:
		return 14
	case layers.LinkTypeNull, layers.LinkTypeLoop:
		return 4
	case layers.LinkTypeRaw:
		return 0
	case layers.LinkTypeLinuxSLL:
		return 16
	}
	return -1
}

// udpCapture relays UDP datagrams to 127.0.0.1 by payload resend (stateless,
// so a plain reinjected packet is indistinguishable from a fresh local send,
// and never touches the app firewall at all).
func udpCapture(name, filter string, out *[65536]*net.UDPConn) {
	ih, err := pcap.NewInactiveHandle(name)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[%s] %v\n", name, err)
		return
	}
	defer ih.CleanUp()
	ih.SetSnapLen(2048)
	ih.SetPromisc(false)
	ih.SetTimeout(pcap.BlockForever)
	ih.SetImmediateMode(true)
	ih.SetBufferSize(4 << 20)

	h, err := ih.Activate()
	if err != nil {
		fmt.Fprintf(os.Stderr, "[%s] %v\n", name, err)
		return
	}
	defer h.Close()
	if err := h.SetBPFFilter(filter); err != nil {
		fmt.Fprintf(os.Stderr, "[%s] filter: %v\n", name, err)
		return
	}
	off := linkOffset(h.LinkType())
	if off < 0 {
		fmt.Fprintf(os.Stderr, "[%s] unsupported linktype %v\n", name, h.LinkType())
		return
	}
	fmt.Printf("[%s] udp capturing (link offset %d)\n", name, off)

	for {
		pkt, _, err := h.ZeroCopyReadPacketData()
		if err != nil {
			fmt.Fprintf(os.Stderr, "[%s] %v\n", name, err)
			return
		}
		if len(pkt) < off+28 || pkt[off]>>4 != 4 || pkt[off+9] != 17 {
			continue
		}
		if pkt[off+6]&0x3f != 0 || pkt[off+7] != 0 { // fragment
			continue
		}
		udp := off + int(pkt[off]&0x0f)*4
		if len(pkt) < udp+8 {
			continue
		}
		dport := int(pkt[udp+2])<<8 | int(pkt[udp+3])
		ulen := int(pkt[udp+4])<<8 | int(pkt[udp+5])
		end := udp + ulen
		if end > len(pkt) {
			end = len(pkt)
		}
		if c := out[dport]; c != nil && end > udp+8 {
			c.Write(pkt[udp+8 : end])
		}
	}
}

func ifaceIPv4(name string) (net.IP, error) {
	ni, err := net.InterfaceByName(name)
	if err != nil {
		return nil, err
	}
	addrs, err := ni.Addrs()
	if err != nil {
		return nil, err
	}
	for _, a := range addrs {
		ipnet, ok := a.(*net.IPNet)
		if !ok {
			continue
		}
		if ip4 := ipnet.IP.To4(); ip4 != nil {
			return ip4, nil
		}
	}
	return nil, fmt.Errorf("no IPv4 address on %s", name)
}

// setupTCPRedirect loads a pf ruleset that redirects inbound TCP for the
// given ports, on each interface's own real address, to 127.0.0.1. This
// routes around the app firewall's post-handshake stream-kill bug entirely:
// once pf rewrites the destination to loopback, the kernel delivers it like
// any other local connection, which the firewall already always allows.
func setupTCPRedirect(ifaces []string, ports map[int]int) error {
	var rules strings.Builder
	for _, name := range ifaces {
		ip, err := ifaceIPv4(name)
		if err != nil {
			fmt.Fprintf(os.Stderr, "[%s] skipping tcp redirect: %v\n", name, err)
			continue
		}
		for p := range ports {
			fmt.Fprintf(&rules, "rdr pass on %s inet proto tcp from any to %s port %d -> 127.0.0.1 port %d\n",
				name, ip, p, p)
		}
	}
	if rules.Len() == 0 {
		return fmt.Errorf("no interface had an IPv4 address to redirect tcp on")
	}
	f, err := os.CreateTemp("", "bpfrelay-pf-*.conf")
	if err != nil {
		return err
	}
	defer os.Remove(f.Name())
	if _, err := f.WriteString(rules.String()); err != nil {
		f.Close()
		return err
	}
	f.Close()

	if out, err := exec.Command("pfctl", "-f", f.Name()).CombinedOutput(); err != nil {
		return fmt.Errorf("pfctl -f: %v: %s", err, out)
	}
	// "pf already enabled" on a second run is fine; only a real failure matters.
	if out, err := exec.Command("pfctl", "-e").CombinedOutput(); err != nil && !strings.Contains(string(out), "already enabled") {
		return fmt.Errorf("pfctl -e: %v: %s", err, out)
	}
	fmt.Print(rules.String())
	return nil
}

// restoreDefaultPF reloads the system's own pf.conf, undoing our ruleset,
// on exit. macOS owns pf for things like Internet Sharing; leaving our
// temporary redirect loaded after the process dies would be surprising.
func restoreDefaultPF() {
	exec.Command("pfctl", "-f", "/etc/pf.conf").Run()
}

func main() {
	var ifaces ifaceList
	flag.Var(&ifaces, "i", "interface (repeatable; default: all up non-loopback)")
	flag.Parse()
	if flag.NArg() == 0 {
		fmt.Fprintln(os.Stderr, "usage: bpfrelay [-i IFACE]... PORT|udp:PORT|tcp:PORT ...")
		os.Exit(2)
	}

	var out [65536]*net.UDPConn
	var udpTerms []string
	tcpPorts := map[int]int{}
	for _, a := range flag.Args() {
		proto, portStr := "udp", a
		if i := strings.IndexByte(a, ':'); i >= 0 {
			proto, portStr = a[:i], a[i+1:]
		}
		p, err := strconv.Atoi(portStr)
		if err != nil || p < 1 || p > 65535 {
			fmt.Fprintf(os.Stderr, "bad port %q\n", a)
			os.Exit(2)
		}
		switch proto {
		case "udp":
			c, err := net.DialUDP("udp4", nil, &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: p})
			if err != nil {
				fmt.Fprintln(os.Stderr, err)
				os.Exit(1)
			}
			out[p] = c
			udpTerms = append(udpTerms, "dst port "+portStr)
		case "tcp":
			tcpPorts[p] = p
		default:
			fmt.Fprintf(os.Stderr, "bad protocol %q (want udp: or tcp:)\n", proto)
			os.Exit(2)
		}
	}
	udpFilter := "udp and not host 127.0.0.1"
	if len(udpTerms) > 0 {
		udpFilter = "udp and (" + strings.Join(udpTerms, " or ") + ") and not host 127.0.0.1"
	}

	if len(ifaces) == 0 {
		all, _ := net.Interfaces()
		for _, i := range all {
			if i.Flags&net.FlagUp != 0 && i.Flags&net.FlagLoopback == 0 {
				ifaces = append(ifaces, i.Name)
			}
		}
	}

	if len(tcpPorts) > 0 {
		if err := setupTCPRedirect(ifaces, tcpPorts); err != nil {
			fmt.Fprintf(os.Stderr, "tcp redirect: %v\n", err)
			os.Exit(1)
		}
		sigs := make(chan os.Signal, 1)
		signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
		go func() {
			<-sigs
			restoreDefaultPF()
			os.Exit(0)
		}()
	}

	var wg sync.WaitGroup
	for _, n := range ifaces {
		wg.Add(1)
		go func(n string) { defer wg.Done(); udpCapture(n, udpFilter, &out) }(n)
	}
	wg.Wait()
}
