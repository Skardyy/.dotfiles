{ pkgs, user, ... }: {
  #   dont forget to put Proton-GE, and game properties:
  #   PROTON_ENABLE_WAYLAND=1 PROTON_VKD3D_LOWLATENCY=1 gamemoderun %command%

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.${user}.extraGroups = [ "gamemode" ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      discord
      umu-launcher
    ];
  };
}
