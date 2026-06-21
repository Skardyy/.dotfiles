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
  };
}
