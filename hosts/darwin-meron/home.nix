{ pkgs, user, ... }: {
  imports = [
    ../../modules/neovim/home.nix
    ../../modules/ghostty/home.nix
    ../../modules/kitty/home.nix
    ../../modules/fish/home.nix
    ../../modules/dev/home.nix
    ../../modules/aerospace/home.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
