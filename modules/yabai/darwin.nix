{ user, mod, ... }: {
  homebrew = {
    taps = [
      "koekeishiya/formulae"
      "gechr/tap"
    ];
    brews = [
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
    ];
    casks = [ "gechr/tap/whichspace" ];
  };

  launchd.user.agents.yabai = {
    serviceConfig = {
      Label = "org.nixos.yabai";
      ProgramArguments = [
        "/opt/homebrew/bin/yabai"
        "-c"
        "/Users/${user}/.config/yabai/yabairc"
      ];
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  launchd.user.agents.skhd = {
    serviceConfig = {
      Label = "org.nixos.skhd";
      ProgramArguments = [
        "/opt/homebrew/bin/skhd"
        "-c"
        "/Users/${user}/.config/skhd/skhdrc"
      ];
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."yabai/yabairc".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/yabai/yabairc";
    xdg.configFile."skhd/skhdrc".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/yabai/skhdrc";
  };
}
