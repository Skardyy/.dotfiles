{ user, mod, ... }: {
  homebrew = {
    taps = [ "koekeishiya/formulae" ];
    brews = [ "koekeishiya/formulae/yabai" ];
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

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."yabai/yabairc".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/yabai/yabairc";
  };
}
