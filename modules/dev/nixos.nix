{ user, ... }: {
  home-manager.users.${user}.imports = [ ./home.nix ];

  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];
}
