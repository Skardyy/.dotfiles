{ inputs, user, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    imports = [ inputs.dms.homeModules.dank-material-shell ];

    xdg.configFile."DankMaterialShell/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/dms/settings.json";

    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableClipboardPaste = true;
    };
  };
}
