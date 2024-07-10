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
      # Create a snapshots directory. It will be used to store periodic snapshots
      # created via btfs subvolume snapshot. Those snapshots will linger for 30 days
      # before they are dropped via systemd-tmpfiles settings.
      tmpfiles.settings."10-snapshots"."/var/lib/snapshots".d = {
        user = "root";
        group = "root";
        age = "30d";
      };

      # Run snapshotting job on a weekly timer. Persistent = true implies
      # that the job will attempt to cover for missed jobs that were supposed
      # to run during downtime.
      timers."snapshot-home" = {
        enable = hasHomeSubvolume;
        description = "snapshot home subvolume";
        wantedBy = ["multi-user.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };

      # Create a service job that will run if the host has a /home subvolume.
      # It will create a snapshot of the /home subvolume and store it in
      # /var/lib/snapshots with a timestamp in its filename.
      # Timestamp format is as follows:
      #  %s - seconds since the Epoch (1970-01-01 00:00 UTC)
      services."snapshot-home" = {
        enable = hasHomeSubvolume;
        path = [pkgs.btrfs-progs];
        script = "btrfs subvolume snapshot /home /var/lib/snapshots/$(date +%s)";
      };
    };
  };
}
