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
        supportedFilesystems = mkForce ["btrfs"];
        initrd = {
          supportedFilesystems = ["btrfs"];
        };
      };
    })

    (mkIf (builtins.elem "ext4" sys.fs) {
      boot = {
        supportedFilesystems = mkForce ["ext4"];
        initrd = {
          supportedFilesystems = ["ext4"];
        };
      };
    })

    (mkIf (builtins.elem "zfs" sys.fs) {
      # TODO
    })

    # accept both ntfs and ntfs3 as valid values
    (mkIf ((builtins.elem "ntfs" sys.fs) || (builtins.elem "ntfs3" sys.fs)) {
      boot = {
        supportedFilesystems = mkForce ["ntfs"];
      };
    })
  ];
}
