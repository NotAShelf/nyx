{
  config,
  pkgs,
  ...
}: {
  boot.loader = {
    systemd-boot.enable = true;
    grub = {
      enable = false;
    };
  };
}
