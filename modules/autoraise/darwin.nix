{ ... }: {
  homebrew = {
    taps = [
      { name = "dimentium/autoraise"; trusted = true; }
    ];
    brews = [
      { name = "autoraise"; args = [ "with-dexperimental_focus_first" ]; }
    ];
  };

  launchd.user.agents.autoraise = {
    serviceConfig = {
      Label = "com.sbmpost.autoraise";
      ProgramArguments = [
        "/opt/homebrew/bin/autoraise"
        "-delay"
        "0"
        "-focusDelay"
        "1"
        "-pollMillis"
        "20"
        "-requireMouseStop"
        "false"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
