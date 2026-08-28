{ pkgs, config, ... }: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      egl-wayland
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords="RmReservePteSysmemMB=128"
  '';

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
