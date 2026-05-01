# Darwin (macOS) migration notes

Currently this config only supports NixOS via flakes. Darwin support is planned via [nix-darwin](https://github.com/LnL7/nix-darwin).

## What needs to happen

- Add `nix-darwin` and `nix-homebrew` to `flake.nix` inputs.
- Add a `darwinConfigurations.<hostname>` block parallel to `nixosConfigurations`.
- Add a host file under `hosts/<mac-hostname>/default.nix` that imports the relevant modules' `darwin.nix` files.

## Modules that need a `darwin.nix`

- **`modules/aerospace/`** (new) — tiling WM for macOS, parallel to niri on Linux.
  - System: `services.aerospace.enable = true;` (provided by nix-darwin)
  - Home: symlink the `aerospace.toml` config file
  - Source: see old `tmp/compositors/aerospace/aerospace.toml`

- **`modules/kanata/darwin.nix`** — keyboard remapping on macOS.
  - Use `launchd.daemons.kanata` to run kanata as root.
  - Requires Karabiner-Elements VirtualHID (install via homebrew cask).
  - Source: see old `tmp/compositors/kanata/kanata.plist`

- **`modules/autoraise/`** (new) — focus-follows-mouse on macOS.
  - Use `launchd.user.agents.autoraise`.
  - Requires homebrew tap `dimentium/autoraise` and the `--with-dexperimental_focus_first` flag (which won't translate cleanly — likely needs to keep using brew).

## Apps that must come from Homebrew (cask-only)

These have no nixpkgs equivalent on macOS. nix-darwin has `homebrew.enable` to manage casks declaratively. Add to the darwin host:

```nix
homebrew = {
  enable = true;
  casks = [
    "karabiner-elements"   # required for kanata
    "raycast"              # launcher (referenced in aerospace config)
    "brave-browser"        # if not via nixpkgs darwin build
  ];
  taps = [ "dimentium/autoraise" ];
  brews = [ "autoraise" ];
};
```

## Modules that already work cross-platform

- `modules/fish/` — `home.nix` is fine; `nixos.nix` becomes `darwin.nix` for the shell config
- `modules/ghostty/` — `home.packages = [ pkgs.ghostty ]` works on darwin too
- `modules/kitty/` — same
- `modules/neovim/` — same
- `modules/dev/` — most packages exist on darwin, may need to drop a few Linux-only ones (e.g. `wl-clipboard`)

## Modules to skip on Darwin

- `modules/niri/`, `modules/dms/`, `modules/pipewire/`, `modules/desktop/` (Linux Wayland stack)
- `modules/gaming/` (steam works, but `gamescopeSession` etc. are Linux-only)
- `modules/virt/` (libvirt is Linux-only; quickemu works on macOS via different invocation)
- `modules/nvidia/` (no NVIDIA on modern macs)

## Open questions

- Where does `aerospace-restart` alias belong? (Already handled in fish config via `uname` switch.)
- Kanata on macOS needs a different config path for the .plist — handle in darwin.nix.
- Autoraise might be cleaner to keep as a brew install and just declare the cask.
