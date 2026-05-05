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

  home-manager.users.${user}.imports = [ ./home.nix ];
}
