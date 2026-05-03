{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.kanata ];

  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "org.kanata.daemon";
      ProgramArguments = [
        "${pkgs.kanata}/bin/kanata"
        "--cfg"
        "/Users/meronbossin/.dotfiles/modules/kanata/kanata.kbd"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardErrorPath = "/tmp/kanata.err.log";
      StandardOutPath = "/tmp/kanata.out.log";
    };
  };
}
