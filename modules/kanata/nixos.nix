{ user, ... }: {
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [ ];
      configFile = "/home/${user}/.config/kanata/kanata.kbd";
      extraDefCfg = "process-unmapped-keys yes";
    };
  };
}
