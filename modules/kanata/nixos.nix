{ user, ... }: {
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [ ];
      configFile = ./kanata.kbd;
      extraDefCfg = "process-unmapped-keys yes";
    };
  };

  users.users.${user}.extraGroups = [ "uinput" ];
}
