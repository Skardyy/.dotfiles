{ pkgs, user, ... }: {
  programs.dconf.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.accounts-daemon.enable = true;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      nautilus
      hyprpicker
      satty
      bibata-cursors
      adw-gtk3
      brave
      wl-clipboard
    ];

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
      };
    };
  };
}
