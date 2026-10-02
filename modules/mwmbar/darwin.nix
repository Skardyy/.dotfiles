{ ... }: {
  homebrew.taps = [
    {
      name = "skardyy/mwmbar";
      clone_target = "https://github.com/Skardyy/mwmbar.git";
      trusted = true;
    }
  ];
  homebrew.brews = [ "mwmbar" ];

  launchd.user.agents.mwmbar = {
    serviceConfig = {
      Label = "com.skardyy.mwmbar";
      ProgramArguments = [ "/opt/homebrew/bin/mwmbar" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardErrorPath = "/tmp/mwmbar.err.log";
      StandardOutPath = "/tmp/mwmbar.out.log";
    };
  };
}
