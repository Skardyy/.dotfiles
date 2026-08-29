{ pkgs, user, ... }: {
  #   dont forget to put Proton-GE, and game properties:
  #   MANGOHUD=1 PROTON_ENABLE_WAYLAND=1 WINEDLLOVERRIDES="nvngx_dlssg=d" gamemoderun %command%
  #
  #   - proton enable is a must, more performance, better nego
  #   - dll override is also a must, games might forcefully insert dlssg into the pipeline even when not enabled, only causes issues
  #   - gamemoderun isn't a must, but couldn't hurt, some games, esp with low fps cap, can have issues with cpu being under util

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

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
      };
    };
  };
}
