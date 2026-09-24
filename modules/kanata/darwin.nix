{ user, pkgs, ... }:
let
  driverVersion = "6.2.0";
  driverPkg = pkgs.fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${driverVersion}/Karabiner-DriverKit-VirtualHIDDevice-${driverVersion}.pkg";
    sha256 = "1a1n0yzp0k6z64bqmdgmh9f4w8h1g62l89748491cj07kwild34y";
  };
in
{
  homebrew.brews = [ "kanata" ];

  environment.etc."sudoers.d/kanata".text = ''
    ${user} ALL=(ALL) NOPASSWD: /opt/homebrew/bin/kanata
  '';

  system.activationScripts.postActivation.text = ''
    stamp=/var/db/karabiner-driverkit.version
    want=${driverVersion}
    have=$(cat "$stamp" 2>/dev/null || echo none)
    if [ "$have" != "$want" ]; then
      echo "installing Karabiner-DriverKit-VirtualHIDDevice $want"
      /usr/sbin/installer -pkg ${driverPkg} -target /
      echo "$want" > "$stamp"
      /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate || true
    fi
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
