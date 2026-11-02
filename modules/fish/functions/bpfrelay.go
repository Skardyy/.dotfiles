package main

import (
	"flag"
	"fmt"
	"net"
	"os"
	"strconv"
	"strings"
	"sync"

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

func capture(name, filter string, out *[65536]*net.UDPConn) {
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
	fmt.Printf("[%s] capturing (link offset %d)\n", name, off)

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

func main() {
	var ifaces ifaceList
	flag.Var(&ifaces, "i", "interface (repeatable; default: all up non-loopback)")
	flag.Parse()
	if flag.NArg() == 0 {
		fmt.Fprintln(os.Stderr, "usage: bpfrelay [-i IFACE]... PORT [PORT...]")
		os.Exit(2)
	}

	var out [65536]*net.UDPConn
	var terms []string
	for _, a := range flag.Args() {
		p, err := strconv.Atoi(a)
		if err != nil || p < 1 || p > 65535 {
			fmt.Fprintf(os.Stderr, "bad port %q\n", a)
			os.Exit(2)
		}
		c, err := net.DialUDP("udp4", nil, &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: p})
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
		out[p] = c
		terms = append(terms, "dst port "+a)
	}
	filter := "udp and (" + strings.Join(terms, " or ") + ") and not host 127.0.0.1"

	if len(ifaces) == 0 {
		all, _ := net.Interfaces()
		for _, i := range all {
			if i.Flags&net.FlagUp != 0 && i.Flags&net.FlagLoopback == 0 {
				ifaces = append(ifaces, i.Name)
			}
		}
	}

	var wg sync.WaitGroup
	for _, n := range ifaces {
		wg.Add(1)
		go func(n string) { defer wg.Done(); capture(n, filter, &out) }(n)
	}
	wg.Wait()
}
