{ user, ... }: {
  homebrew = {
    taps = [
      { name = "hashicorp/tap"; trusted = true; }
    ];
    brews = [
      "gstreamer"
      "gst-plugins-base"
      "gst-plugins-good"
      "gst-plugins-bad"
      "gst-plugins-ugly"
      "gst-libav"
      "mediamtx"
      "awscli"
      "azure-cli"
      "pulumi"
      "hashicorp/tap/terraform"
    ];
    casks = [
      "claude-code"
      "orbstack"
      "wireshark-app"
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
