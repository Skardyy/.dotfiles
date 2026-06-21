{ user, mod, ... }: {
  homebrew.casks = [ "hammerspoon" ];

  # Bind cmd+1..9 to native Switch to Desktop N. Needs to be reverted manually.
  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys =
  let
    cmd = 1048576;
    bind = keyChar: keyCode: {
      enabled = true;
      value = { type = "standard"; parameters = [ keyChar keyCode cmd ]; };
    };
  in {
    "118" = bind 49 18; # cmd+1 -> Desktop 1
    "119" = bind 50 19; # cmd+2 -> Desktop 2
    "120" = bind 51 20; # cmd+3 -> Desktop 3
    "121" = bind 52 21; # cmd+4 -> Desktop 4
    "122" = bind 53 23; # cmd+5 -> Desktop 5
    "123" = bind 54 22; # cmd+6 -> Desktop 6
    "124" = bind 55 26; # cmd+7 -> Desktop 7
    "125" = bind 56 28; # cmd+8 -> Desktop 8
    "126" = bind 57 25; # cmd+9 -> Desktop 9
  };

  launchd.user.agents.hammerspoon = {
    serviceConfig = {
      Label = "org.hammerspoon.Hammerspoon";
      ProgramArguments = [ "/Applications/Hammerspoon.app/Contents/MacOS/Hammerspoon" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  home-manager.users.${user} = { config, ... }: {
    home.file.".hammerspoon/init.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/init.lua";
    home.file.".hammerspoon/macos_spaces.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/macos_spaces.lua";
    home.file.".hammerspoon/cpu.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/cpu.lua";
  };
}
