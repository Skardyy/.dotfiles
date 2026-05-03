{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    stremio-linux-shell
    umu-launcher
  ];
}
