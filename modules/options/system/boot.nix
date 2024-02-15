{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) literalExpression mkEnableOption mkOption types;

  cfg = config.modules.system.boot;
in {
  # pre-boot and bootloader configurations
  options.modules.system.boot = {
    enableKernelTweaks = mkEnableOption "security and performance related kernel parameters";
    recommendedLoaderConfig = mkEnableOption "tweaks for common bootloader configs per my liking";
    loadRecommendedModules = mkEnableOption "kernel modules that accommodate for most use cases";
    tmpOnTmpfs = mkEnableOption "`/tmp` living on tmpfs. false means it will be cleared manually on each reboot";

    secureBoot = mkEnableOption ''
      secure-boot with the necessary packages. Requires systemd-boot to be disabled
    '';

    silentBoot =
      mkEnableOption ''
        almost entirely silent boot process through `quiet` kernel parameter
      ''
      // {default = config.modules.system.boot.plymouth.enable;};

    initrd = {
      enableTweaks = mkEnableOption "quality of life tweaks for the initrd stage";
      optimizeCompressor = mkEnableOption ''
        initrd compression algorithm optimizations for size.

        Enabling this option will force initrd to use zstd (default) with
        level 19 and -T0 (STDIN). This will reduce the initrd size greatly
        at the cost of compression speed.

        Not recommended for low-end hardware.
      '';
    };

    kernel = mkOption {
      type = with types; nullOr raw;
      default = null;
      example = literalExpression "pkgs.linuxPackages_latest";
      description = "The kernel to use for the system.";
    };

    extraModprobeConfig = mkOption {
      type = types.str;
      default = ''options hid_apple fnmode=1'';
      description = "Extra modprobe config that will be passed to system modprobe config.";
    };

    extraKernelParams = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Extra kernel parameters to be added to the kernel command line.";
    };

    extraModulePackages = mkOption {
      type = with types; listOf package;
      default = [];
      example = literalExpression ''with config.boot.kernelPackages; [acpi_call]'';
      description = "Extra kernel modules to be loaded.";
    };

    loader = mkOption {
      type = types.enum ["none" "grub" "systemd-boot"];
      default = "none";
      description = "The bootloader that should be used for the device.";
    };

    grub = {
      device = mkOption {
        type = with types; nullOr str;
        default = "nodev";
        description = "The device to install the bootloader to.";
      };
    };

    plymouth = {
      enable = mkEnableOption "Plymouth boot splash";
      withThemes = mkEnableOption ''
        Whether or not themes from https://github.com/adi1090x/plymouth-themes
        should be enabled and configured
      '';

      pack = mkOption {
        type = types.enum [1 2 3 4];
        default = 3;
        description = "The pack number for the theme to be selected from.";
      };

      theme = mkOption {
        type = types.str;
        default = "hud_3";
        description = "The theme name from the selected theme pack";
      };
    };

    memtest = {
      enable = mkEnableOption "memtest86+";
      package = mkOption {
        type = types.package;
        default = pkgs.memtest86plus;
        description = "The memtest package to use.";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.kernel != null;
        message = ''
          Your system does not specify a kernel package. This is intended behaviour
          and is to avoid specifying default kernels that are not compatible with
          active hardware.

          To supress this error, you must set `config.modules.system.boot.kernel`
          to a valid kernel package.
        '';
      }
    ];
  };
}
