{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.device;
in {
  config = {
    modules = {
      # device specific settings
      device = {
        # device type/purpose
        # "laptop" adds desktop modules with batter optimizations
        type = "laptop";

        # device cpu and gpu
        cpu = "intel"; # see modules/system/default.nix for available types
        gpu = "intel"; # see modules/system/default.nix for available types

        # available/in-use monitor(s)
        # accepts more than one string
        # e.g. ["eDP-1" "HDMI-A-1"]
        monitors = ["eDP-1"];

        # device capabilities
        hasBluetooth = true; # does the device support bluetooth
        hasSound = true; # does the device have any audio output
        hasTPM = true; # can you install windows 11 on this device
      };
      # system specific configuration
      system = {
        # desired display protocol - wayland is default
        # setting this value to false will disable wayland
        # and enable xorg
        isWayland = true;

        # desired filesystem support
        # TODO: dynamically add kernel modules for supported filesystems
        fs = ["btrfs" "vfat"];

        # desired media capabilities
        video.enable = true; # enable video support
        sound.enable = true; # enable audio support

        # user settings
        username = "notashelf";
      };
    };

    # we enable and modify tpm2 *per host* because not all devices I own
    # actually support tmp2, i.e my Pi 400 will error out if tmp2 is enabled
    security.tmp2 = {
      # enable Trusted Platform Module 2 support
      enable = cfg.hasTMP;
      # enable Trusted Platform 2 userspace resource manager daemon
      abrmd.enable = true;
      # set TCTI environment variables to the specified values if enabled
      # - TPM2TOOLS_TCTI
      # - TPM2_PKCS11_TCTI
      tctiEnvironment.enable = true;
      # enable TPM2 PKCS#11 tool and shared library in system path
      pkcs11.enable = true;
    };

    # filesystem options that are *generally* specific to hosts
    # TODO: this might be mixed into the common "btrfs" module in the future
    # might want to finalize my preferred btrfs schema before I do that
    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      # allow usage of potentially proprietary firmware blobs
      enableRedistributableFirmware = true;

      # device-specific GPU quirks that don't belong in a global module

      nvidia = {
        # my GPU is not properly supported by open source drivers
        open = mkForce false;
        # nvidia prime configuration
        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot = {
      # Override the default lts and my default mainline kernel with your own
      # FIXME xanmod causes regular kernel to become unable to be built
      # latest xanmod Linux kernel for speed and android
      # boot.kernelPackages = with pkgs; linuxPackages_xanmod_latest;

      # Kernel parameters specific to this device
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
    };
  };
}
