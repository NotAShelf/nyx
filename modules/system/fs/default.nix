{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.fs;
in {
  config = mkMerge [
    (mkIf (device.fs == "btrfs") {
      # scrub btrfs devices
      services.btrfs.autoScrub.enable = true;

      # this fixes initrd.systemd for whatever reason
      boot = {
        initrd = {
          supportedFilesystems = ["btrfs"];
        };
      };
    })

    (mkIf (device.fs == "ext4") {
      # TODO
    })

    (mkIf (device.fs == "zfs") {
      # TODO
    })
  ];
}
