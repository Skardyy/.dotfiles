{ user, mod, ... }: {
  homebrew = {
    taps = [
      { name = "nikitabobko/tap"; trusted = true; }
    ];
    casks = [ "aerospace" ];
  };

  # Enables ctrl+cmd+drag anywhere on window body to move it. Hammerspoon's
  # cmd_drag.lua adds the ctrl flag so plain cmd+drag triggers the OS move,
  # which aerospace observes and swap/re-tiles.
  system.defaults.CustomUserPreferences.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

  launchd.user.agents.aerospace = {
    serviceConfig = {
      Label = "com.nikitabobko.aerospace";
      ProgramArguments = [ "/Applications/AeroSpace.app/Contents/MacOS/AeroSpace" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."aerospace/aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/aerospace/aerospace.toml";
  };
}
