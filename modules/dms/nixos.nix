{ inputs, user, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."DankMaterialShell/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/dms/settings.json";

    home.sessionVariables.DMS_SCREENSHOT_EDITOR = "satty";
  };

  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = false;

    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableClipboardPaste = true;
  };
}
