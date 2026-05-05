{ pkgs, user, ... }: {
  home-manager.users.${user} = {
    imports = [ ./home.nix ];
    home.packages = [ pkgs.ghostty ];
  };
}
