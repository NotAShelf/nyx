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
    ./emulation.nix
    ./programs.nix
    ./services.nix
    ./printing.nix
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
      else if config.modules.system.users == []
      then [
        ''
          You do not have a main user set. This may cause issues with some modules.
        ''
      ]
      else [];
  };

  options.modules.system = {
    mainUser = mkOption {
      type = types.enum config.modules.system.users;
      description = "The username of the main user for your system";
      default = builtins.elemAt config.modules.system.users 0;
    };

    users = mkOption {
      type = with types; listOf str;
      default = ["notashelf"];
      description = lib.mdDoc ''
        A list of users that you wish to declare as your non-system users. The first username
        in the list will be treated as your main user unless `modules.system.mainUser` is set.
      '';
    };

    autologin = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable passwordless login. This is generally useful on systems with
        FDE (Full Disk Encryption) enabled. It is a security risk for systems without FDE.
      '';
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

    # should sound related programs and audio-dependent programs be enabled
    sound = {
      enable = mkEnableOption "sound (Pipewire)";
    };

    # should the device enable graphical programs
    video = {
      enable = mkEnableOption "video drivers";
    };

    # should the device load bluetooth drivers and enable blueman
    bluetooth = {
      enable = mkEnableOption "bluetooth module and drivers";
    };

    yubikeySupport = {
      enable = mkEnableOption "yubikey support";
      deviceType = mkOption {
        type = with types; nullOr enum ["NFC5" "nano"];
        default = null;
        description = "A list of devices to enable Yubikey support for";
      };
    };
  };
}
