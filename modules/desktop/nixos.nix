{ pkgs, user, mod, ... }: {
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  home-manager.users.${user} = { config, ... }: {
    home.packages = with pkgs; [
      nautilus
      hyprpicker
      satty
      grim
      slurp
      bibata-cursors
      adw-gtk3
      wl-clipboard
    ];

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };
    home.sessionVariables.QS_ICON_THEME = "Papirus-Dark";

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
      };
    };

    home.file.".local/bin/screenshot".source =
      config.lib.file.mkOutOfStoreSymlink "${mod}/desktop/screenshot.sh";
  };
}
