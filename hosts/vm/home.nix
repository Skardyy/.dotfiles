{ pkgs, user, ... }: {
  imports = [
    ../../modules/niri/home.nix
    ../../modules/dms/home.nix
    ../../modules/ghostty/home.nix
    ../../modules/fish/home.nix
    ../../modules/neovim/home.nix
    ../../modules/dev/home.nix
    ../../modules/desktop/home.nix
    ../../modules/gaming/home.nix
    ../../modules/virt/home.nix
    ../../modules/kanata/home.nix
    ../../modules/kitty/home.nix
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
