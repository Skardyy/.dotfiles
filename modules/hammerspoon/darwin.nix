{ user, mod, ... }: {
  homebrew.casks = [ "hammerspoon" ];

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
