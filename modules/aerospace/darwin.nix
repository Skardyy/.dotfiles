{ ... }: {
  homebrew = {
    taps = [ "nikitabobko/tap" "dimentium/autoraise" ];
    brews = [ "autoraise" ];
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

  launchd.user.agents.autoraise = {
    serviceConfig = {
      Label = "com.sbmpost.autoraise";
      ProgramArguments = [ "/opt/homebrew/bin/autoraise" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
