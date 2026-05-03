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
  ];

  nix-homebrew = {
    enable = true;
    user = user;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    taps = [ "dimentium/autoraise" "nikitabobko/tap" ];
    brews = [ "autoraise" ];
    casks = [
      "karabiner-elements"
      "brave-browser"
      "aerospace"
      "claude-code"
    ];
  };

  nix.enable = false;

  system.primaryUser = user;

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.fish;
  };

  launchd.user.agents.autoraise = {
    serviceConfig = {
      Label = "com.sbmpost.autoraise";
      ProgramArguments = [ "/opt/homebrew/bin/autoraise" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  launchd.user.agents.aerospace = {
    serviceConfig = {
      Label = "com.nikitabobko.aerospace";
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  environment.variables = {
    NH_FLAKE = "/Users/${user}/.dotfiles";
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
