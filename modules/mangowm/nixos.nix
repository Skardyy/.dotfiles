{ inputs, user, mod, ... }: {
  imports = [ inputs.mangowm.nixosModules.mango ];

  programs.mango.enable = true;

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."mango/config.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/mangowm/config.conf";

    xdg.configFile."mango/modules".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/mangowm/modules";
  };
}
