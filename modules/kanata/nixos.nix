{ user, lib, ... }: {
  services.kanata = {
    enable = true;
    keyboards.default = {
      devices = [ ];
      configFile = ./kanata.kbd;
      extraDefCfg = "process-unmapped-keys yes";
    };
  };

  systemd.services.kanata-default = {
    wantedBy = lib.mkForce [ "graphical.target" ];
    before = lib.mkForce [ ];
    after = lib.mkForce [ "graphical.target" ];
  };

  users.users.${user}.extraGroups = [ "uinput" ];
}
