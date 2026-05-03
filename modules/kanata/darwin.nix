{ pkgs, ... }:
let
  cfg = "/Users/meronbossin/.dotfiles/modules/kanata/kanata.kbd";
in
{
  environment.systemPackages = [ pkgs.kanata ];

  homebrew.casks = [ "karabiner-elements" ];

  environment.etc."sudoers.d/kanata".text = ''
    meronbossin ALL=(ALL) NOPASSWD: ${pkgs.kanata}/bin/kanata
  '';

  launchd.user.agents.kanata = {
    serviceConfig = {
      Label = "org.kanata.agent";
      ProgramArguments = [
        "/usr/bin/sudo"
        "-n"
        "${pkgs.kanata}/bin/kanata"
        "--cfg"
        cfg
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardErrorPath = "/tmp/kanata.err.log";
      StandardOutPath = "/tmp/kanata.out.log";
    };
  };
}
