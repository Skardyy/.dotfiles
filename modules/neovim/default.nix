{ user, pkgs, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    home.packages = [ pkgs.neovim ];

    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/neovim/config";
  };
}
