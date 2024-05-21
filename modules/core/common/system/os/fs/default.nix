{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf mkDefault;

  sys = config.modules.system;
  inherit (sys.fs) btrfs enabledFilesystems;
in {
  config = {
    # Add enabled filesystems to the kernel module list
    # by adding them to supportedFilesystems in `boot` and `boot.initrd`.
    # The former is only required of you plan to use systemd support
    # in stage one.
    boot = {
      supportedFilesystems = enabledFilesystems;
      initrd = {
        supportedFilesystems = enabledFilesystems;
      };
    };

    # If  lvm is enabled, then tell it to issue discard. This is
    # good for SSDs and has almost no downsides on HDDs, so
    # it's a good idea to enable it unconditionally.
    environment.etc."lvm/lvm.conf".text = mkIf config.services.lvm.enable ''
      devices {
        issue_discards = 1
      }
    '';

    services = {
      # btrfs-scrub systemd service for periodically scrubbing listed
      # filesystems, which defaults to `/`. The service will be enabled
      # by default if btrfs support is advertised by the host.
      btrfs.autoScrub = mkIf (elem "btrfs" enabledFilesystems) {
        inherit (btrfs.scrub) enable interval fileSystems;
      };

      # I don't use lvm, can be disabled
      lvm.enable = mkDefault false;

      # Discard blocks that are not in use by the filesystem, should be
      # generally good for SSDs. This service is enabled by default, but
      # I am yet to test the performance impact on a system with no SSDs.
      fstrim = {
        # we may enable this unconditionally across all systems because it's performance
        # impact is negligible on systems without a SSD - which means it's a no-op with
        # almost no downsides aside from the service firing once per week
        enable = true;

        # the default value, good enough for average-load systems
        interval = "weekly";
      };
    };

    # Tweak fstrim service to run only when on AC power
    # and to be nice to other processes. This is a generally
    # a good idea for any service that runs periodically to
    # save power and avoid locking down the system in an
    # unexpected manner, e.g., while working on something else.
    systemd.services.fstrim = {
      unitConfig.ConditionACPower = true;

      serviceConfig = {
        Nice = 19; # lowest priority, be nice to other processes
        IOSchedulingClass = "idle";
      };
    };
  };
}
