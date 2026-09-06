{ ... }: {
  homebrew = {
    casks = [
      "raycast"
      "betterdisplay"
    ];
  };

  # Free cmd+space for Raycast. Needs to be reverted manually.
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
    "64" = { enabled = false; }; # Spotlight (cmd+space)
    "65" = { enabled = false; }; # Finder search window (cmd+opt+space)
    "28" = { enabled = false; }; # Screenshot whole screen to file (cmd+shift+3)
    "30" = { enabled = false; }; # Screenshot selection to file (cmd+shift+4)

    # Screenshot/recording tool: cmd+shift+5 -> cmd+shift+s
    "184" = {
      enabled = true;
      value = {
        type = "standard";
        parameters = [ 115 1 1179648 ];
      };
    };
  };
}
