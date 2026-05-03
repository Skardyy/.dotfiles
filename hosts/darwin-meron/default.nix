{ config, pkgs, inputs, ... }:
let
  user = "meronbossin";
in
{
  _module.args = { inherit user; };

  home-manager.users.${user} = import ./home.nix;

  imports = [
    ../base
    ../../modules/fish/darwin.nix
    ../../modules/kanata/darwin.nix
    ../../modules/fonts.nix
    ../../modules/ghostty/darwin.nix
    ../../modules/desktop/darwin.nix
    ../../modules/dev/darwin.nix
    ../../modules/aerospace/darwin.nix
  ];

  nix-homebrew = {
    enable = true;
    user = user;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
  };

  nix.enable = false;

  system.primaryUser = user;

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };

  environment.variables = {
    NH_FLAKE = "/Users/${user}/.dotfiles";
  };

  networking.hostName = "darwin-meron";

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
    };
    finder = {
      CreateDesktop = false;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
    };
  };

  system.stateVersion = 6;
}
