{ pkgs, user, lib, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };

  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];

  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  programs.virt-manager.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" "kvm" ];

  environment.systemPackages = with pkgs; [
    qemu
    virtiofsd
  ];

  home-manager.users.${user} = {
    home.packages = [ pkgs.quickemu ];
  };
}
