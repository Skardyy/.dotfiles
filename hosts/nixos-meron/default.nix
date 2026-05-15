{ pkgs, ... }:
let
  user = "meron";
  mod = "/home/${user}/.dotfiles/modules";
in
{
  _module.args = { inherit user mod; };

  imports = [
    ../base
    ./hardware.nix
    ../../modules/fonts
    ../../modules/dev/nixos.nix
    ../../modules/fish/nixos.nix
    ../../modules/niri/nixos.nix
    ../../modules/dms/nixos.nix
    ../../modules/pipewire/nixos.nix
    ../../modules/bluetooth/nixos.nix
    ../../modules/desktop/nixos.nix
    ../../modules/gaming/nixos.nix
    ../../modules/virt/nixos.nix
    ../../modules/kanata/nixos.nix
    ../../modules/nvidia/nixos.nix
    ../../modules/ghostty/nixos.nix
    ../../modules/git
    ../../modules/kitty
    ../../modules/neovim
  ];
  home-manager.users.${user} = {
    home.username = user;
    home.homeDirectory = "/home/${user}";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
  };

  services.displayManager.ly = {
    enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-meron";
  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;
  location.provider = "geoclue2";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      openssl
      glib
      icu
    ];
  };
  programs.nh = {
    enable = true;
    flake = "/home/${user}/.dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
  nix.package = pkgs.lixPackageSets.stable.lix;
  system.stateVersion = "26.05";
}
