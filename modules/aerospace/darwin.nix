{ user, mod, ... }: {
  homebrew = {
    taps = [ "nikitabobko/tap" "dimentium/autoraise" ];
    brews = [ "autoraise" ];
    casks = [ "aerospace" ];
  };

  launchd.user.agents.autoraise = {
    serviceConfig = {
      Label = "com.sbmpost.autoraise";
      ProgramArguments = [ "/opt/homebrew/bin/autoraise" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."aerospace/aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/aerospace/aerospace.toml";
  };
}
