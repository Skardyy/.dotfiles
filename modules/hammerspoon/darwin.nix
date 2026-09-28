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
    home.file.".hammerspoon/workspace_bar".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/workspace_bar";
    home.file.".hammerspoon/cmd_drag.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/cmd_drag.lua";
    home.file.".hammerspoon/cpu.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/cpu.lua";
    home.file.".hammerspoon/sources".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/hammerspoon/sources";
  };
}
