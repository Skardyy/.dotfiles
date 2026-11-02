package main

import (
	"encoding/binary"
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
	"time"

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

func ipv4Checksum(b []byte) uint16 {
	var sum uint32
	for i := 0; i+1 < len(b); i += 2 {
		sum += uint32(b[i])<<8 | uint32(b[i+1])
	}
	if len(b)%2 == 1 {
		sum += uint32(b[len(b)-1]) << 8
	}
	for sum>>16 != 0 {
		sum = (sum & 0xffff) + (sum >> 16)
	}
	return ^uint16(sum)
}

// udpSession is one external client's half of a relayed UDP port: an
// ephemeral loopback socket wired to that one client, so a reply (e.g. a
// STUN binding response, or any other request/response protocol) can be
// shipped back out to the real address it came from.
type udpSession struct {
	conn     *net.UDPConn
	lastSeen time.Time
}

// natUDP relays UDP both ways: inbound payload resend to loopback is
// indistinguishable from a fresh local send (so it clears the app firewall
// for free), and replies are read back off each client's dedicated loopback
// socket and reinjected onto the wire as a fresh UDP/IP/Ethernet frame
// addressed to that client. Needed for any protocol where the loopback
// service talks back (WebRTC ICE/STUN on 8189 being the motivating case);
// harmless overhead for one-way streams like RTP ingest or telemetry.
func natUDP(name, filter string, ports map[int]bool, selfMAC net.HardwareAddr, selfIP net.IP, handle *pcap.Handle, off int) {
	var mu sync.Mutex
	sessions := map[string]*udpSession{}

	go func() {
		for range time.Tick(30 * time.Second) {
			mu.Lock()
			for k, s := range sessions {
				if time.Since(s.lastSeen) > 60*time.Second {
					s.conn.Close()
					delete(sessions, k)
				}
			}
			mu.Unlock()
		}
	}()

	writeback := func(clientMAC net.HardwareAddr, clientIP net.IP, clientPort, localPort int, payload []byte) {
		udp := make([]byte, 8+len(payload))
		binary.BigEndian.PutUint16(udp[0:2], uint16(localPort))
		binary.BigEndian.PutUint16(udp[2:4], uint16(clientPort))
		binary.BigEndian.PutUint16(udp[4:6], uint16(len(udp)))
		copy(udp[8:], payload)
		pseudo := make([]byte, 12+len(udp))
		copy(pseudo[0:4], selfIP.To4())
		copy(pseudo[4:8], clientIP.To4())
		pseudo[9] = 17
		binary.BigEndian.PutUint16(pseudo[10:12], uint16(len(udp)))
		copy(pseudo[12:], udp)
		if cksum := ipv4Checksum(pseudo); cksum != 0 {
			binary.BigEndian.PutUint16(udp[6:8], cksum)
		} else {
			binary.BigEndian.PutUint16(udp[6:8], 0xffff)
		}

		ip := make([]byte, 20+len(udp))
		ip[0] = 0x45
		binary.BigEndian.PutUint16(ip[2:4], uint16(len(ip)))
		ip[8] = 64 // ttl
		ip[9] = 17 // udp
		copy(ip[12:16], selfIP.To4())
		copy(ip[16:20], clientIP.To4())
		binary.BigEndian.PutUint16(ip[10:12], ipv4Checksum(ip[:20]))
		copy(ip[20:], udp)

		frame := make([]byte, 14+len(ip))
		copy(frame[0:6], clientMAC)
		copy(frame[6:12], selfMAC)
		frame[12], frame[13] = 0x08, 0x00
		copy(frame[14:], ip)
		if err := handle.WritePacketData(frame); err != nil {
			fmt.Fprintf(os.Stderr, "[%s] udp writeback: %v\n", name, err)
		}
	}

	for {
		pkt, _, err := handle.ZeroCopyReadPacketData()
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
		if !ports[dport] {
			continue
		}
		sport := int(pkt[udp+0])<<8 | int(pkt[udp+1])
		ulen := int(pkt[udp+4])<<8 | int(pkt[udp+5])
		end := udp + ulen
		if end > len(pkt) || end <= udp+8 {
			end = len(pkt)
		}
		payload := append([]byte(nil), pkt[udp+8:end]...)
		clientIP := append(net.IP(nil), pkt[off+12:off+16]...)
		clientMAC := append(net.HardwareAddr(nil), pkt[6:12]...)

		key := fmt.Sprintf("%s:%d:%d", clientIP, sport, dport)
		mu.Lock()
		sess, ok := sessions[key]
		if !ok {
			conn, err := net.DialUDP("udp4", nil, &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: dport})
			if err != nil {
				mu.Unlock()
				fmt.Fprintf(os.Stderr, "[%s] dial 127.0.0.1:%d: %v\n", name, dport, err)
				continue
			}
			sess = &udpSession{conn: conn, lastSeen: time.Now()}
			sessions[key] = sess
			go func(conn *net.UDPConn, clientMAC net.HardwareAddr, clientIP net.IP, clientPort int) {
				buf := make([]byte, 65536)
				for {
					n, err := conn.Read(buf)
					if err != nil {
						return
					}
					writeback(clientMAC, clientIP, clientPort, dport, buf[:n])
				}
			}(conn, clientMAC, clientIP, sport)
		}
		sess.lastSeen = time.Now()
		mu.Unlock()
		sess.conn.Write(payload)
	}
}

func ifaceMAC(name string) (net.HardwareAddr, error) {
	ni, err := net.InterfaceByName(name)
	if err != nil {
		return nil, err
	}
	return ni.HardwareAddr, nil
}

func udpCapture(name, filter string, ports map[int]bool) {
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
	selfMAC, err := ifaceMAC(name)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[%s] mac: %v\n", name, err)
		return
	}
	selfIP, err := ifaceIPv4(name)
	if err != nil {
		fmt.Fprintf(os.Stderr, "[%s] ip: %v\n", name, err)
		return
	}
	fmt.Printf("[%s] udp capturing (link offset %d)\n", name, off)
	natUDP(name, filter, ports, selfMAC, selfIP, h, off)
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

	udpPorts := map[int]bool{}
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
			udpPorts[p] = true
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
		go func(n string) { defer wg.Done(); udpCapture(n, udpFilter, udpPorts) }(n)
	}
	wg.Wait()
}
