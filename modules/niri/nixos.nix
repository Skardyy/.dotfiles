{ pkgs, ... }: {
  programs.niri.enable = true;

  environment.systemPackages = [ pkgs.xwayland-satellite ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
