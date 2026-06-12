{ inputs, user, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    imports = [ inputs.dms.homeModules.dank-material-shell ];

    xdg.configFile."DankMaterialShell/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/dms/settings.json";

    home.sessionVariables.DMS_SCREENSHOT_EDITOR = "satty";

    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableClipboardPaste = true;
    };
  };
}
