{ config, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/kanata";
in
{
  xdg.configFile."kanata/kanata.kbd".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/kanata.kbd";
}
