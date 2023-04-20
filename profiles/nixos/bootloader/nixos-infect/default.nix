{lib, ...}: {
      services.btrfs.autoScrub.enable = lib.mkForce false;

  boot.loader = {
    systemd-boot.enable = false;
    grub = {
      enable = lib.mkForce false;
    };
  };
}
