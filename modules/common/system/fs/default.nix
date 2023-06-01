{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  sys = config.modules.system;
in {
  config = mkMerge [
    (mkIf (builtins.elem "btrfs" sys.fs) {
      # scrub btrfs devices
      services.btrfs.autoScrub.enable = true;

      # this fixes initrd.systemd.enable for whatever reason
      boot = {
        supportedFilesystems = ["btrfs"];
        initrd = {
          supportedFilesystems = ["btrfs"];
        };
      };
    })

    (mkIf (builtins.elem "ext4" sys.fs) {
      boot = {
        supportedFilesystems = ["ext4"];
        initrd = {
          supportedFilesystems = ["ext4"];
        };
      };
    })

    (mkIf (builtins.elem "exfat" sys.fs) {
      boot = {
        supportedFilesystems = ["exfat"];
        initrd = {
          supportedFilesystems = ["exfat"];
        };
      };
    })

    (mkIf (builtins.elem "zfs" sys.fs) {
      # TODO: zfs needs a lot of options to be enabled, perhaps this could be its own separate module once I start using zfs for basically anything
    })

    # accept both ntfs and ntfs3 as valid values
    (mkIf ((builtins.elem "ntfs" sys.fs) || (builtins.elem "ntfs3" sys.fs)) {
      boot = {
        supportedFilesystems = ["ntfs"];
      };
    })
  ];
}
