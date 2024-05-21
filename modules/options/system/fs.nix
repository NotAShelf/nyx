{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.lists) optionals;
  inherit (lib.types) listOf str enum;

  # Filesystems supported by my module system. To make sure no
  # additional filesystems sneak into the supportedFilesystems lists
  # of the `boot` and `boot.initrd` module options, we define them
  # inside an enum that will be checked.
  supportedFilesystems = ["vfat" "ext4" "btrfs" "exfat" "ntfs"];
in {
  options.modules.system.fs = {
    enabledFilesystems = mkOption {
      type = listOf (enum supportedFilesystems);
      default = ["vfat"];
      description = ''
        List of filesystems that will be supported by the current host.

        Adding a valid filesystem to this list will automatically add
        said filesystem to the `supportedFilesystems` attribute of the
        `boot` and `boot.initrd` module options.

        It would be a good idea to keep vfat and ext4 so you can mount
        common external storage.

        ::: {.note}
        The default value contains vfat, as it is a common filesystem
        for boot partitions. If you wish to override this option, you
        may want to `mkForce` your preferred list of filesystems to
        override the default.
        :::
      '';
    };

    # FS specific options
    # BTRFS
    btrfs = {
      scrub = {
        enable = mkEnableOption "automatic scrubbing of btrfs subvolumes" // {default = true;};
        interval = mkOption {
          type = str;
          default = "weekly";
          description = ''
            Interval at which the scrubbing of btrfs subvolumes should
            be performed.

            See {manpage}`systemd.time(7)` for more information on the
            syntax.
          '';
        };

        fileSystems = mkOption {
          type = listOf str;
          default = ["/"];
          description = ''
            List of btrfs subvolumes to scrub. By default, only the
            root subvolume will be scrubbed.
          '';
        };
      };
    };
  };

  config = {
    warnings = optionals (config.modules.system.fs == []) [
      ''
        You have not added any filesystems to be supported by your system! Without
        any filesystems enabled, you may end up with an unbootable system! You should
        consider {option}`config.modules.system.fs` in your configuration with one or
        two filesysteems used by your booted disks.

        If this is an installation media, you may discard this warning.
      ''
    ];
  };
}
