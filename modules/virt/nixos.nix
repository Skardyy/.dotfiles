{ pkgs, user, ... }: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" "kvm" ];

  environment.systemPackages = with pkgs; [
    qemu_full
  ];
}
