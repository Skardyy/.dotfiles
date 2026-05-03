{ config, pkgs, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/fish";
in
{
  home.packages = with pkgs; [
    fishPlugins.tide
  ];

  xdg.configFile."fish/config.fish".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/config.fish";
}
