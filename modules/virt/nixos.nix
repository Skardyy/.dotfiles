{ pkgs, user, lib, ... }: {
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  programs.virt-manager.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" "kvm" ];

  environment.systemPackages = with pkgs; [
    qemu_full
  ];

  home-manager.users.${user} = {
    home.packages = [ pkgs.quickemu ];
  };
}
