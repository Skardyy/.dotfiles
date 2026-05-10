{ user, ... }: {
  homebrew.brews = [ "kanata" ];
  homebrew.casks = [ "karabiner-elements" ];

  environment.etc."sudoers.d/kanata".text = ''
    ${user} ALL=(ALL) NOPASSWD: /opt/homebrew/bin/kanata
  '';

  launchd.user.agents.kanata = {
    serviceConfig = {
      Label = "org.kanata.agent";
      ProgramArguments = [
        "/usr/bin/sudo"
        "-n"
        "/opt/homebrew/bin/kanata"
        "--cfg"
        "${./kanata.kbd}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardErrorPath = "/tmp/kanata.err.log";
      StandardOutPath = "/tmp/kanata.out.log";
    };
  };
}
