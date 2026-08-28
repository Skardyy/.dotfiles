{ pkgs, lib, ... }:
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
    ../../modules/mangowm/nixos.nix
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
    ../../modules/zen
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
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.automatic-timezoned.enable = true;

  fileSystems."/boot".options = [ "fmask=0077" "dmask=0077" "nofail" "x-systemd.device-timeout=5s" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  specialisation.stable-kernel.configuration = {
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.hostName = "nixos-meron";
  networking.networkmanager.enable = true;

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

  system.stateVersion = "26.05";
}
