{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../system/serv/services.nix
    ../../system/common.nix
  ];
  boot.loader = {
    systemd-boot.enable = true;
    grub = {
      enable = false;
    };
  };
}
