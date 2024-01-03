{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./systemd

    ./zram.nix
  ];

  services = {
    # monitor and control temparature
    thermald.enable = true;

    # discard blocks that are not in use by the filesystem, good for SSDs
    fstrim.enable = true;

    # firmware updater for machine hardware
    fwupd = {
      enable = true;
      daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };

    # I don't use lvm, can be disabled
    lvm.enable = mkDefault false;

    # enable smartd monitoring
    smartd = {
      enable = mkDefault true;
      notifications = {
        x11.enable = config.services.xserver.enable;
      };
    };
  };
}
