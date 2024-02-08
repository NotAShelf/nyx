{
  config,
  lib,
  ...
}: let
  inherit (lib) optionals mkEnableOption mkOption types;
in {
  imports = [
    # configuration options for nixos activation scripts
    ./activation.nix

    # boot/impermanence mounts
    ./boot.nix
    ./impermanence.nix

    # network and overall hardening
    ./networking
    ./security.nix
    ./encryption.nix

    # emulation and virtualization
    ./emulation.nix
    ./virtualization.nix

    # package and program related options
    ./services
    ./programs

    # systemd-nspawn containers
    ./containers.nix
  ];
  config = {
    warnings =
      (optionals (config.modules.system.fs == []) [
        ''
          You have not added any filesystems to be supported by your system. You may end up with an unbootable system!

          Consider setting {option}`config.modules.system.fs` in your configuration
        ''
      ])
      ++ (optionals (config.modules.system.users == []) [
        ''
          You have not added any users to be supported by your system. You may end up with an unbootable system!

          Consider setting {option}`config.modules.system.users` in your configuration
        ''
      ]);
  };

  options.modules.system = {
    mainUser = mkOption {
      type = types.enum config.modules.system.users;
      default = builtins.elemAt config.modules.system.users 0;
      description = ''
        The username of the main user for your system.

        In case of a multiple systems, this will be the user with priority in ordered lists and enabled options.
      '';
    };

    users = mkOption {
      type = with types; listOf str;
      default = ["notashelf"];
      description = "A list of home-manager users on the system.";
    };

    autoLogin = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable passwordless login. This is generally useful on systems with
        FDE (Full Disk Encryption) enabled. It is a security risk for systems without FDE.
      '';
    };

    fs = mkOption {
      type = with types; listOf str;
      default = ["vfat" "ext4" "btrfs"]; # TODO: zfs, ntfs
      description = ''
        A list of filesystems available supported by the system
        it will enable services based on what strings are found in the list.

        It would be a good idea to keep vfat and ext4 so you can mount common external storage.
      '';
    };

    yubikeySupport = {
      enable = mkEnableOption "yubikey support";
      deviceType = mkOption {
        type = with types; nullOr (enum ["NFC5" "nano"]);
        default = null;
        description = "A list of device models to enable Yubikey support for";
      };
    };

    sound = {
      enable = mkEnableOption "sound related programs and audio-dependent programs";
    };

    video = {
      enable = mkEnableOption "video drivers and programs that require a graphical user interface";
    };

    bluetooth = {
      enable = mkEnableOption "bluetooth modules, drivers and configuration program(s)";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
      extraDrivers = mkOption {
        type = with types; listOf str;
        default = [];
        description = "A list of extra drivers to enable for printing";
      };

      "3d" = {
        enable = mkEnableOption "3D printing suite";
        extraPrograms = mkOption {
          type = with types; listOf package;
          default = [];
          description = "A list of extra programs to enable for 3D printing";
        };
      };
    };
  };
}
