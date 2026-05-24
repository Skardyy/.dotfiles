{ user, mod, ... }: {
  homebrew = {
    taps = [ "nikitabobko/tap" ];
    casks = [ "aerospace" ];
  };

  launchd.user.agents.aerospace = {
    serviceConfig = {
      Label = "com.nikitabobko.aerospace";
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."aerospace/aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/aerospace/aerospace.toml";
  };
}
