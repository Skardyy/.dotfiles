{ ... }: {
  homebrew = {
    taps = [ "dimentium/autoraise" "nikitabobko/tap" ];
    brews = [ "autoraise" ];
    casks = [
      "karabiner-elements"
      "brave-browser"
      "aerospace"
      "raycast"
    ];
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
}
