{ config, inputs, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/dms";
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  xdg.configFile."DankMaterialShell/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/settings.json";

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableClipboardPaste = true;
  };
}
