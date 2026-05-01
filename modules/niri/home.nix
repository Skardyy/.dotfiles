{ config, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/niri";
in
{
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/config.kdl";

  xdg.configFile."niri/modules".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/modules";
}
