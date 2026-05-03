{ pkgs, ... }: {
  imports = [ ./home.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    brave
  ];
}
