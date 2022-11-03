{
  config,
  pkgs,
  ...
}: {
  # Change default bootloader to grub
  loader = {
    systemd-boot.enable = false;
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      enableCryptodisk = false;
      device = "nodev";
      theme = null;
      backgroundColor = null;
      splashImage = null;
    };
  };
}
