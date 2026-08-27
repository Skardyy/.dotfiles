if status is-interactive
    if test -f ~/.config/fish/tmp.fish
        source ~/.config/fish/tmp.fish
    end

    fish_add_path "$HOME/.local/bin"
    fish_add_path "$HOME/.cargo/bin"
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/platform-tools

    set -gx PROFILE "$HOME/.config/fish/config.fish"
    set -gx ANDROID_HOME /home/meron/Android/Sdk/
    set -gx GIT_EDITOR nvim
    set -gx SUDO_EDITOR nvim
    set -gx EDITOR nvim
    set -gx GIT_EXTERNAL_DIFF difft
    set -gx PULUMI_CONFIG_PASSPHRASE
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
    set -gx MCAT_TIMEOUT 2

    alias v="nvim"
    alias o="mcat"
    alias pine="PROTONPATH=GE-Proton umu-run"
    alias aerospace-restart='pkill AeroSpace; sleep 0.5; open -a AeroSpace'
    alias ls="eza --icons --group-directories-first"
    alias ll="eza --icons --group-directories-first -lh --git"
    alias la="eza --icons --group-directories-first -lah --git"
    switch (uname)
        case Darwin
            alias scb='pbcopy'
        case Linux
            alias scb='wl-copy'
    end

    function nr
        nix run "nixpkgs#$argv[1]" -- $argv[2..]
    end
    function nsl
        argparse d/dev -- $argv
        or return

        if set -q _flag_dev
            set -l pkgs (string join ' ' (for p in $argv; echo "pkgs.$p"; end))
            nix develop --impure --expr "
            let pkgs = import <nixpkgs> {}; in
            pkgs.mkShell {
                nativeBuildInputs = [ pkgs.pkg-config ];
                buildInputs = [ $pkgs ];
            }
        " --command fish
        else if test (count $argv) -eq 0
            nix develop -c fish
        else
            nix shell "nixpkgs#$argv[1]" $argv[2..]
        end
    end
    function ns
        nix search "nixpkgs#" $argv
    end

    function e
        set -l target "."
        if test (count $argv) -gt 0
            set target $argv[1]
        end

        set -l target_path (realpath "$target")

        switch (uname)
            case Darwin
                open "$target_path"
            case Linux
                niri msg action spawn -- nautilus "$target_path"
        end
    end

    function arpwho
        argparse h/help 'i/interface=' a/all -- $argv
        or return 1

        if set -q _flag_help
            echo "usage: arpwho [-i IFACE] [-a]"
            echo "  -i, --interface   skip the picker"
            echo "  -a, --all         include ASK/REPLY chatter"
            return 0
        end

        if test (count $argv) -gt 0
            echo "arpwho: unexpected argument '$argv[1]' — did you mean '-i $argv[1]'?" >&2
            return 1
        end

        if not command -q tshark
            echo "arpwho: tshark not found — brew install wireshark" >&2
            return 1
        end

        # ------------------------------------------------------------------
        # Pick an interface: only ones that are up and carry an IPv4 address
        # ------------------------------------------------------------------
        set -l iface $_flag_interface

        if test -z "$iface"
            set -l names
            set -l ips
            set -l ports
            set -l tags
            set -l default_if (route -n get default 2>/dev/null | awk '/interface:/{print $2}')

            for dev in (ifconfig -l | tr ' ' '\n')
                # skip loopback and virtual plumbing
                string match -qr '^(lo|gif|stf|utun|awdl|llw|anpi|ap\d)' $dev; and continue

                set -l info (ifconfig $dev 2>/dev/null)
                string match -q '*status: active*' -- "$info"; or continue

                set -l ip (printf '%s\n' $info | awk '/inet /{print $2; exit}')
                test -z "$ip"; and continue

                # friendly name from the hardware port list, e.g. "Wi-Fi"
                set -l port (networksetup -listallhardwareports 2>/dev/null \
                | awk -v d=$dev '/^Hardware Port:/{p=substr($0,16)} $0 ~ "Device: "d"$" {print p; exit}')

                # bridges are not hardware ports; label them by what they bridge
                if test -z "$port"
                    if string match -qr '^bridge' $dev
                        set -l members (printf '%s\n' $info \
                        | awk '/member: /{printf "%s ", $2}' | string trim)
                        if test -n "$members"
                            set port "bridge:$members"
                        else
                            set port bridge
                        end
                    else
                        set port "—"
                    end
                end

                set -l tag ""
                test "$dev" = "$default_if"; and set tag "(*)"

                set -a names $dev
                set -a ips $ip
                set -a ports $port
                set -a tags $tag
            end

            if test (count $names) -eq 0
                echo "arpwho: no active interfaces with an IPv4 address" >&2
                return 1
            end

            if test (count $names) -eq 1
                set iface $names[1]
                echo "arpwho: only one active interface — using $iface" >&2
            else
                # size every column to its widest entry
                set -l w_dev 0
                set -l w_ip 0
                set -l w_port 0
                for i in (seq (count $names))
                    set -l l (string length $names[$i])
                    test $l -gt $w_dev; and set w_dev $l
                    set -l l (string length $ips[$i])
                    test $l -gt $w_ip; and set w_ip $l
                    set -l l (string length $ports[$i])
                    test $l -gt $w_port; and set w_port $l
                end

                echo "" >&2
                echo "Active interfaces" >&2
                echo "" >&2
                for i in (seq (count $names))
                    set -l d (string pad -r -w $w_dev  $names[$i])
                    set -l a (string pad -r -w $w_ip   $ips[$i])
                    set -l p (string pad -r -w $w_port $ports[$i])
                    echo (string trim -r -- "$i)  $d  $a  $p  $tags[$i]") >&2
                end
                echo "" >&2

                # default to the interface holding the default route, else the first
                set -l def 1
                for i in (seq (count $names))
                    test "$names[$i]" = "$default_if"; and set def $i
                end

                if not read -l -P "select [1-"(count $names)"] ($names[$def]): " choice
                    # ctrl-c or ctrl-d at the prompt: abort, do not pick a default
                    echo "" >&2
                    return 130
                end

                # bare enter takes the default
                set choice (string trim -- $choice)
                if test -z "$choice"
                    set choice $def
                end

                if not string match -qr '^\d+$' -- "$choice"
                    echo "arpwho: not a number" >&2
                    return 1
                end
                if test $choice -lt 1 -o $choice -gt (count $names)
                    echo "arpwho: out of range" >&2
                    return 1
                end
                set iface $names[$choice]
            end
        end

        set -l showall 0
        set -q _flag_all; and set showall 1

        sudo -v; or return 1

        echo "arpwho: listening on $iface — ctrl-c to stop" >&2
        printf '%-10s %-18s %-15s %s\n' EVENT MAC IP HOSTNAME >&2

        sudo tshark -i $iface -l -n -Q \
            -f 'arp or udp port 67 or udp port 5353' \
            -T fields -E 'separator=/t' -E 'occurrence=f' \
            -e eth.src \
            -e arp.opcode \
            -e arp.isgratuitous \
            -e arp.src.proto_ipv4 \
            -e arp.dst.proto_ipv4 \
            -e dhcp.option.dhcp \
            -e dhcp.option.hostname \
            -e dns.resp.name 2>/dev/null | awk -F '\t' -v showall=$showall '
      BEGIN {
        dt[1]="DISCOVER"; dt[2]="OFFER"; dt[3]="REQUEST"; dt[4]="DECLINE"
        dt[5]="ACK";      dt[6]="NAK";   dt[7]="RELEASE"; dt[8]="INFORM"
      }
      {
        mac=tolower($1); op=$2; grat=$3; sip=$4; tip=$5
        dhcptype=$6; dhcpname=$7; dnsname=$8
        if (mac == "") next

        if (dhcpname != "") name[mac] = dhcpname
        if (dnsname ~ /\.local$/ && dnsname !~ /_/) {
          h = dnsname; sub(/\.local$/, "", h)
          if (h != "" && !(mac in name)) name[mac] = h
        }

        ev = ""; ip = ""
        if (dhcptype != "") {
          ev = (dhcptype in dt) ? dt[dhcptype] : "DHCP-" dhcptype
          ip = (sip != "" ? sip : "-")
        }
        else if (op == "1" && sip == "0.0.0.0") { ev="PROBE";    ip=tip }
        else if (grat == "1" || grat == "True") { ev="ANNOUNCE"; ip=sip }
        else if (op == "1")                     { ev="ASK";      ip=tip }
        else if (op == "2")                     { ev="REPLY";    ip=sip }
        else next

        if (!showall && (ev == "ASK" || ev == "REPLY")) next

        n = (mac in name) ? name[mac] : "?"
        printf "%-10s %-18s %-15s %s\n", ev, mac, (ip == "" ? "?" : ip), n
        fflush()
      }
    '
    end
end
