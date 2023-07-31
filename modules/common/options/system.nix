{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    warnings =
      if config.modules.system.fs == []
      then [
        ''          You have not added any filesystems to be supported by your system. You may end up with an unbootable system!
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
    username = mkOption {
      type = types.str;
      description = "The username of the non-root superuser for your system";
    };

    # no actual use yet, do not use
    hostname = mkOption {
      type = types.str;
    };

    fs = mkOption {
      type = types.listOf types.string;
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

    # pre-boot and bootloader configurations
    boot = {
      enableKernelTweaks = mkEnableOption "security and performance related kernel parameters";
      enableInitrdTweaks = mkEnableOption "quality of life tweaks for the initrd stage";
      recommendedLoaderConfig = mkEnableOption "tweaks for common bootloader configs per my liking";
      loadRecommendedModules = mkEnableOption "kernel modules that accommodate for most use cases";
      tmpOnTmpfs = mkEnableOption "/tmp should living tmpfs. false means it will be cleared manually on each reboot";

      extraKernelParams = mkOption {
        type = with types; listOf string;
        default = [];
      };

      kernel = mkOption {
        type = types.raw;
        default = pkgs.linuxPackages_latest;
      };

      # the bootloader that should be used
      loader = mkOption {
        type = types.enum ["none" "grub" "systemd-boot"];
        default = "none";
        description = "The bootloader that should be used for the device.";
      };

      plymouth = {
        enable = mkEnableOption "plymouth boot splash";
        withThemes =
          mkEnableOption null
          // {
            description = mdDoc ''
              Whether or not themes from https://github.com/adi1090x/plymouth-themes
              should be enabled and configured
            '';
          };

        pack = mkOption {
          type = types.int;
          default = 3;
        };

        theme = mkOption {
          type = types.str;
          default = "hud_3";
        };
      };
    };

    # ephemeral root through impermanence and btrfs snapshots
    impermanence = {
      root = {
        enable = mkEnableOption (mdDoc ''
          Enable the Impermanence module for persisting important state directories.
          By default, Impermanence will not touch user's $HOME, which is not ephemeral unlike root.
        '');

        extraFiles = mkOption {
          default = [];
          example = [
            "/etc/nix/id_rsa"
          ];
          description = mdDoc ''
            Additional files in the root to link to persistent storage.
          '';
        };

        extraDirectories = mkOption {
          default = [];
          example = [
            "/var/lib/libvirt"
          ];
          description = mdDoc ''
            Additional directories in the root to link to persistent
            storage.
          '';
        };
      };

      home = {
        enable = mkEnableOption (mdDoc ''
          Enable the Impermanence module for persisting important state directories.
          This option will also make user's home ephemeral, on top of the root subvolume
        '');

        home = {
          mountDotfiles = lib.mkOption {
            default = true;
            description = ''
              Whether the repository with my configuration flake should be bound to a location in $HOME after a rebuild
              It will symlink ''${SELF} to ~/.config/nyx where I usually put my configuration files
            '';
          };

          extraFiles = lib.mkOption {
            default = [];
            example = [
              ".gnupg/pubring.kbx"
              ".gnupg/sshcontrol"
              ".gnupg/trustdb.gpg"
              ".gnupg/random_seed"
            ];
            description = ''
              Additional files in the home directory to link to persistent
              storage.
            '';
          };

          extraDirectories = lib.mkOption {
            default = [];
            example = [
              ".config/gsconnect"
            ];
            description = ''
              Additional directories in the home directory to link to
              persistent storage.
            '';
          };
        };
      };
    };

    # should virtualization (docker, qemu, podman etc.) be enabled
    virtualization = {
      enable = mkEnableOption "virtualization";
      docker = {enable = mkEnableOption "docker";};
      podman = {enable = mkEnableOption "podman";};
      qemu = {enable = mkEnableOption "qemu";};
      waydroid = {enable = mkEnableOption "waydroid";};
    };

    # should we optimize tcp networking
    networking = {
      optimizeTcp = mkOption {
        type = types.bool;
        default = false;
        description = "Enable tcp optimizations";
      };

      useTailscale = mkOption {
        type = types.bool;
        default = false;
        description = "Use Tailscale for inter-machine VPN.";
      };

      # TODO: optionally use encrypted DNS
      # encryptDns = mkOption {};
    };

    security = {
      fixWebcam = mkOption {
        type = types.bool;
        default = false;
        description = "Fix the purposefully broken webcam by un-blacklisting the related kernel module.";
      };

      secureBoot = mkEnableOption "Enable secure-boot and load necessary packages.";

      tor = {
        enable = mkEnableOption "Tor daemon" // {default = true;};
      };
    };
  };
}
