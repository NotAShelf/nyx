{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) filterAttrs;

  btrfsMounts = filterAttrs (_: mount: mount.fsType == "btrfs") config.fileSystems;
  hasHomeSubvolume = (filterAttrs (_: mount: mount.mountPoint == "/home") btrfsMounts) != {};
in {
  config = mkIf (btrfsMounts != {}) {
    systemd = {
      # create the snapshots directory
      # it will linger for 30 days before it's dropped
      # this serves as an easy way to persist the snapshots
      # for a set amount of time
      tmpfiles.settings."10-snapshots"."/var/lib/snapshots".d = {
        user = "root";
        group = "root";
        age = "30d";
      };

      # run the snapshots on a weekly timer
      timers.snapshot-home = {
        enable = hasHomeSubvolume;
        description = "snapshot home subvolume";
        wantedBy = ["multi-user.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };

      # create a snapshot of the /home subvolume
      # it will be stored in /var/lib/snapshots with a timestamp
      #  %s - seconds since the Epoch (1970-01-01 00:00 UTC)
      services.snapshot-home = {
        enable = hasHomeSubvolume;
        path = [pkgs.btrfs-progs];
        script = "btrfs subvolume snapshot /home /var/lib/snapshots/$(date +%s)";
      };
    };
  };
}
