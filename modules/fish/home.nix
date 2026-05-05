{ config, pkgs, mod, ... }: {
  home.packages = with pkgs; [
    fishPlugins.tide
  ];

  xdg.configFile."fish/config.fish".source =
    config.lib.file.mkOutOfStoreSymlink "${mod}/fish/config.fish";
}
