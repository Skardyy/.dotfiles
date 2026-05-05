{ pkgs, user, ... }: {
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;
  users.users.${user}.shell = pkgs.fish;

  home-manager.users.${user}.imports = [ ./home.nix ];
}
