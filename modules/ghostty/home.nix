{ config, pkgs, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/ghostty";
in
{
  home.packages = with pkgs; [ ghostty ];

  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/config";

  xdg.configFile."ghostty/cursor_warp.glsl".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/cursor_warp.glsl";
}
