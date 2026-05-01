{ config, pkgs, ... }:
let
  here = "${config.home.homeDirectory}/.dotfiles/modules/neovim";
in
{
  home.packages = [ pkgs.neovim ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${here}/config";
}
