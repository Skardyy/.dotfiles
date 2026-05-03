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
  ];

  nix-homebrew = {
    enable = true;
    user = user;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [ "dimentium/autoraise" ];
    brews = [ "autoraise" ];
    casks = [
      "karabiner-elements"
      "brave-browser"
    ];
  };

  users.users.${user} = {
    home = "/Users/${user}";
  };

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
