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
      device = {
        type = "laptop";
        cpu = "intel";
        gpu = "intel";
        monitors = ["eDP-1"];
        hasBluetooth = true;
        hasSound = true;
        hasTPM = true;
      };
      system = {
        fs = ["btrfs" "vfat" "ntfs"];
        video.enable = true;
        sound.enable = true;
        username = "notashelf";
      };
      usrEnv = {
        isWayland = true;
        desktop = ["hyprland"];
        useHomeManager = true;
      };
    };

    security.tpm2 = {
      # enable Trusted Platform Module 2 support
      enable = cfg.hasTPM;
      # enable Trusted Platform 2 userspace resource manager daemon
      abrmd.enable = mkDefault true;
      # set TCTI environment variables to the specified values if enabled
      # - TPM2TOOLS_TCTI
      # - TPM2_PKCS11_TCTI
      tctiEnvironment.enable = mkDefault true;
      # enable TPM2 PKCS#11 tool and shared library in system path
      pkcs11.enable = mkDefault true;
    };

    fileSystems = {
      "/".options = ["compress=zstd" "noatime"];
      "/home".options = ["compress=zstd"];
      "/nix".options = ["compress=zstd" "noatime"];
    };

    hardware = {
      enableRedistributableFirmware = true;
    };

    boot = {
      kernelParams = [
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "nohibernate"
      ];
    };
  };
}
