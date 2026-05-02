{ config, pkgs, inputs, ... }:
let
  user = "meron";
in
{
  _module.args = { inherit user; };

  home-manager.users.${user} = import ./home.nix;

  imports = [
    ../base
    ./hardware.nix
    ../../modules/fonts.nix
    ../../modules/fish/nixos.nix
    ../../modules/niri/nixos.nix
    ../../modules/pipewire/nixos.nix
    ../../modules/desktop/nixos.nix
    ../../modules/gaming/nixos.nix
    ../../modules/virt/nixos.nix
    ../../modules/kanata/nixos.nix
    ../../modules/nvidia/nixos.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-meron";
  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;
  location.provider = "geoclue2";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "uinput" ];
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
}
