{ user, pkgs, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    home.packages = [ pkgs.kitty ];

    xdg.configFile."kitty/kitty.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/kitty/kitty.conf";
  };
}
