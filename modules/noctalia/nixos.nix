{ inputs, user, mod, ... }: {
  home-manager.users.${user} = { config, ... }: {
    imports = [ inputs.noctalia.homeModules.default ];

    xdg.configFile."noctalia/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/noctalia/settings.json";

    programs.noctalia-shell.enable = true;
  };
}
