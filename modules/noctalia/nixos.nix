{ inputs, user, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    imports = [ inputs.noctalia.homeModules.default ];

    xdg.configFile."noctalia/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/noctalia/settings.json";

    home.file.".local/state/noctalia/settings.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/noctalia/settings.toml";

    programs.noctalia-shell.enable = true;
  };
}
