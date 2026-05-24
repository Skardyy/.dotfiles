{ user, mod, ... }: {
  homebrew = {
    taps = [
      "dimentium/autoraise"
      "koekeishiya/formulae"
    ];
    brews = [
      "dimentium/autoraise/autoraise"
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
    ];
  };

  launchd.user.agents.autoraise = {
    serviceConfig = {
      Label = "com.sbmpost.autoraise";
      ProgramArguments = [ "/opt/homebrew/bin/autoraise" "-delay" "0" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  launchd.user.agents.yabai = {
    serviceConfig = {
      Label = "org.nixos.yabai";
      ProgramArguments = [ "/opt/homebrew/bin/yabai" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  launchd.user.agents.skhd = {
    serviceConfig = {
      Label = "org.nixos.skhd";
      ProgramArguments = [ "/opt/homebrew/bin/skhd" ];
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
