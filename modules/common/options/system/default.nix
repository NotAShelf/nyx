{
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    ./impermanence.nix
    ./networking.nix
    ./security.nix
    ./boot.nix
    ./activation.nix
    ./virtualization.nix
  ];
  config = {
    warnings =
      if config.modules.system.fs == []
      then [
        ''
          You have not added any filesystems to be supported by your system. You may end up with an unbootable system!
          Consider setting `config.modules.system.fs` in your configuration
        ''
      ]
      else [];
  };

  options.modules.system = {
    # the default user (not users) you plan to use on a specific device
    # this will dictate the initial home-manager settings if home-manager is
    # enabled in usrEnv
    # TODO: allow for a list of usernames, map them individually to homes/<username>
    users = mkOption {
      type = with types; listOf str;
      default = ["notashelf"];
      description = "The username of the non-root superuser for your system";
    };

    mainUser = mkOption {
      type = types.enum config.modules.system.users;
      description = "The username of the main user for your system";
      default = builtins.elemAt config.modules.system.users 0;
    };

    # no actual use yet, do not use
    hostname = mkOption {
      type = types.str;
    };

    fs = mkOption {
      type = with types; listOf str;
      default = ["vfat" "ext4" "btrfs"]; # TODO: zfs, ntfs
      description = mdDoc ''
        A list of filesystems available supported by the system
        it will enable services based on what strings are found in the list.

        It would be a good idea to keep vfat and ext4 so you can mount USBs.
      '';
    };

    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    emulation = {
      enable = mkEnableOption "cpu architecture emulation via qemu";
    };

    yubikeySupport = {
      enable = mkEnableOption "yubikey support";
      deviceType = mkOption {
        type = with types; nullOr enum ["NFC5" "nano"];
        default = null;
        description = "A list of devices to enable Yubikey support for";
      };
    };

    # should sound related programs and audio-dependent programs be enabled
    sound = {
      enable = mkEnableOption "sound (Pipewire)";
    };

    # should the device enable graphical programs
    video = {
      enable = mkEnableOption "video drivrs";
    };

    # should the device load bluetooth drivers and enable blueman
    bluetooth = {
      enable = mkEnableOption "bluetooth module and drivers";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
      "3d".enable = mkEnableOption "3D printing suite";
    };
  };
}
