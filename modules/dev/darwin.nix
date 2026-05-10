{ user, ... }: {
  homebrew = {
    brews = [
      "gstreamer"
      "gst-plugins-base"
      "gst-plugins-good"
      "gst-plugins-bad"
      "gst-libav"
      "mediamtx"
    ];
    casks = [
      "claude-code"
      "orbstack"
    ];
  };

  launchd.user.agents.orbstack = {
    serviceConfig = {
      ProgramArguments = [ "/Applications/OrbStack.app/Contents/MacOS/xbin/orb" "start" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  home-manager.users.${user}.imports = [ ./home.nix ];
}
