{ pkgs, user, ... }: {
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  system.activationScripts.postActivation.text = ''
    /usr/bin/dscl . -create /Users/${user} UserShell /run/current-system/sw/bin/fish
  '';

  home-manager.users.${user}.imports = [ ./home.nix ];
}
