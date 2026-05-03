{ config, pkgs, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/kitty";
in
{
  home.packages = [ pkgs.kitty ];

  xdg.configFile."kitty/kitty.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/kitty.conf";
}
