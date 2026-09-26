{ pkgs, user, ... }: {
  #   dont forget to put Proton-GE, and game properties:
  #   gamemoderun %command%

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        PROTON_FSR4_UPGRADE = "1";
        MANGOHUD = "1";
        PROTON_ENABLE_WAYLAND = "1";
      };
    };

    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

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

    programs.mangohud = {
      enable = true;
      settings = {
        no_display = true;
        toggle_hud = "F10";
        fps = true;
        frame_timing = 1;
        gpu_stats = true;
        vram = true;
        gamemode = true;
      };
    };
  };
}
