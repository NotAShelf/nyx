{
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.system = {
    # the default user (not users) you plan to use on a specific device
    # this will dictate the initial home-manager settings if home-manager is
    # enabled in usrenv
    username = mkOption {
      type = types.str;
    };

    # no actual use yet, do not use
    hostname = mkOption {
      type = types.str;
    };

    # a list of filesystems available on the system
    # it will enable services based on what strings are found in the list
    fs = mkOption {
      type = types.listOf types.string;
      default = ["vfat" "ext4" "btrfs"]; # TODO: zfs, ntfs
    };

    # should we enable emulation for additional architechtures?
    # enabling this option will make it so that you can build for, e.g.
    # aarch64 on x86_&4 and vice verse - not recommended on weaker machines
    emulation = {
      enable = mkEnableOption "emulation";
    };

    # should sound related programs and audio-dependent programs be enabled
    sound = {
      enable = mkEnableOption "sound";
    };

    # should the device enable graphical programs
    video = {
      enable = mkEnableOption "video";
    };

    # should the device load bluetooth drivers and enable blueman
    bluetooth = {
      enable = mkEnableOption "bluetooth";
    };

    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    printing = {
      enable = mkEnableOption "printing";
    };

    # pre-boot and bootloader configurations
    boot = {
      enableKernelTweaks = mkEnableOption "security and performance related kernel parameters";
      enableInitrdTweaks = mkEnableOption "quality of life tweaks for the initrd stage";
      recommendedLoaderConfig = mkEnableOption "tweaks for common bootloader configs per my liking";
      loadRecommendedModules = mkEnableOption "kernel modules that accommodate for most use cases";
      tmpOnTmpfs = mkEnableOption "whether or not /tmp should live on tmpfs. false means it will be cleared manually on each reboot";

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
    };

    # should virtualization (docker, qemu, podman etc.) be enabled
    virtualization = {
      enable = mkEnableOption "virtualization";
      docker = {enable = mkEnableOption "docker";};
      podman = {enable = mkEnableOption "podman";};
      qemu = {enable = mkEnableOption "qemu";};
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
    };

    security = {
      fixWebcam = mkOption {
        type = types.bool;
        default = false;
        description = "Fix the purposefully broken webcam by un-blacklisting the related kernel module.";
      };

      secureBoot = mkOption {
        type = types.bool;
        default = false;
        description = "Enable secure-boot and load necessary packages.";
      };

      tor = {
        enable = mkEnableOption "Tor daemon" // {default = true;};
      };
    };
  };
}
