{ user, ... }: {
  home-manager.users.${user}.imports = [ ./home.nix ];
}
