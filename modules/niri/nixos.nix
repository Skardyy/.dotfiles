{ pkgs, user, mod, ... }: {
  programs.niri.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  home-manager.users.${user} = { config, ... }: {
    xdg.configFile."niri/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/niri/config.kdl";

    xdg.configFile."niri/modules".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/niri/modules";
  };
}
