{ pkgs, ... }: {
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [ ];
      configFile = ./kanata.kbd;
      extraDefCfg = "process-unmapped-keys yes";
    };
  };
}
