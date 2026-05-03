{ pkgs, ... }: {
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;
}
