{ config, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/aerospace";
in
{
  xdg.configFile."aerospace/aerospace.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/aerospace.toml";
}
