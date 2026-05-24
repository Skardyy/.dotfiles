{ ... }:
let
  user = "meronbossin";
  mod = "/Users/${user}/.dotfiles/modules";
in
{
  _module.args = { inherit user mod; };
  environment.variables = {
    NH_FLAKE = "/Users/${user}/.dotfiles";
  };

  imports = [
    ../base
    ../../modules/fish/darwin.nix
    ../../modules/kanata/darwin.nix
    ../../modules/fonts
    ../../modules/ghostty/darwin.nix
    ../../modules/desktop/darwin.nix
    ../../modules/dev/darwin.nix
    ../../modules/aerospace/darwin.nix
    ../../modules/autoraise/darwin.nix
    ../../modules/git
    ../../modules/kitty
    ../../modules/neovim
  ];

  nix-homebrew = {
    enable = true;
    user = user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = false;
      upgrade = false;
    };
  };
  nix.enable = false;

  system.primaryUser = user;
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

  users.users.${user} = {
    home = "/Users/${user}";
  };
  home-manager.users.${user} = {
    home.username = user;
    home.homeDirectory = "/Users/${user}";
    home.stateVersion = "26.05";

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
    };

    programs.home-manager.enable = true;
  };
}
