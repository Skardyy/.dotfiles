{ ... }:
{
  services.openssh.enable = true;

  networking.networkmanager.ensureProfiles.profiles.share = {
    connection = { id = "share"; type = "ethernet"; interface-name = "enp2s0"; autoconnect = true; };
    ipv4 = {
      method = "shared";
      address1 = "10.42.0.1/24";
      shared-dhcp-range = "10.42.0.50,10.42.0.50";
    };
    ipv6.method = "ignore";
  };

  networking.firewall.trustedInterfaces = [ "enp2s0" ];
}
