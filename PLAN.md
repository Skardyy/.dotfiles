# Dotfiles → Nix Migration Plan

## Context
You want to move this repo from Dotbot-managed mac/arch dotfiles to a Nix flake that can serve:
- NixOS system configuration (`nixosConfigurations`)
- macOS system configuration via nix-darwin (`darwinConfigurations`)
- Arch user configuration via home-manager only (`homeConfigurations`), plus a small custom script for system tweaks

The desired layout is:
- `hosts/` for host definitions (arch/mac/nix)
- `modules/` for standalone modules (mostly app install + app config), kept user-agnostic
- A root `flake.nix` as the entry point, minimizing or ignoring legacy `configuration.nix`

## Idea
Make the flake the single source of truth and keep host files thin. Use modules to encapsulate app setups, and separate system-level logic from user-level logic:
- `modules/home/` for home-manager modules (cross-platform)
- `modules/nixos/` for NixOS system modules
- `modules/darwin/` for nix-darwin system modules

Each host imports:
- A shared common host config
- The modules it needs
- System-specific modules (NixOS/darwin) as needed

## Plan
1. Create the new directory layout and scaffold the flake with inputs for nixpkgs, home-manager, and nix-darwin.
2. Add hosts for `arch`, `mac`, and `nix`, plus a `hosts/common.nix` shared module list.
3. Add module folders (`modules/home`, `modules/nixos`, `modules/darwin`) with starter placeholders.
4. Wire home-manager into both NixOS and nix-darwin, and expose `homeConfigurations` for Arch.
5. Add a simple Arch-only post-install script for system tweaks that Nix cannot handle (from existing installers).
6. Update `README.md` to explain the new Nix workflow and de-emphasize Dotbot (keep it as legacy if desired).

## Checklist
- [ ] Add `flake.nix` (and `flake.lock` after initial eval)
- [ ] Create `hosts/arch.nix`, `hosts/mac.nix`, `hosts/nix.nix`, and `hosts/common.nix`
- [ ] Create `modules/home/`, `modules/nixos/`, `modules/darwin/` folders with starter modules
- [ ] Wire outputs: `nixosConfigurations.nix`, `darwinConfigurations.mac`, `homeConfigurations.arch`
- [ ] Add Arch system tweak script (minimal)
- [ ] Update `README.md` with Nix instructions and migration notes
