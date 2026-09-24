{ user, mod, ... }: {
  homebrew = {
    taps = [ "acsandmann/tap" ];
    brews = [ "acsandmann/tap/rift" ];
  };

  launchd.user.agents.rift = {
    serviceConfig = {
      Label = "com.acsandmann.rift";
      ProgramArguments = [ "/opt/homebrew/bin/rift" ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      Nice = -5;
      LowPriorityIO = false;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."rift/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/rift/rift.toml";
  };
}
