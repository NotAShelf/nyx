{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) listOf str enum;

  # Filesystems supported by my module system. To make sure no
  # additional filesystems sneak into the supportedFilesystems lists
  # of the `boot` and `boot.initrd` module options, we define them
  # inside an enum that will be checked.
  supportedFilesystems = ["vfat" "ext4" "btrfs" "exfat" "ntfs"];

  sys = config.modules.system;
  cfg = sys.fs;
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
}
