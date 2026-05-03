# Darwin (macOS) setup

## Prerequisites

### Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```

### Apply

First time:

```sh
darwin-rebuild switch --flake .#darwin-meron
```

After that, use nh:

```sh
nh darwin switch
```

### Kanata

Karabiner VirtualHID must be activated manually after install:

```sh
/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
```

Then in System Settings:

- General → Login Items & Extensions → Driver Extensions → enable Karabiner
- Enable both the normal and privileged Karabiner daemons in Login Items
- Privacy & Security → Input Monitoring → add `/opt/homebrew/bin/kanata`
