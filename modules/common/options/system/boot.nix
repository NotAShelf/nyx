{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mdDoc;
in {
  # pre-boot and bootloader configurations
  options.modules.system.boot = {
    enableKernelTweaks = mkEnableOption "security and performance related kernel parameters";
    enableInitrdTweaks = mkEnableOption "quality of life tweaks for the initrd stage";
    recommendedLoaderConfig = mkEnableOption "tweaks for common bootloader configs per my liking";
    loadRecommendedModules = mkEnableOption "kernel modules that accommodate for most use cases";
    tmpOnTmpfs = mkEnableOption "/tmp living on tmpfs. false means it will be cleared manually on each reboot";

    extraKernelParams = mkOption {
      type = with types; listOf str;
      default = [];
      description = "Extra kernel parameters to be added to the kernel command line.";
    };

    kernel = mkOption {
      type = types.raw;
      default = pkgs.linuxPackages_latest;
      description = "The kernel to use for the system.";
    };

    loader = mkOption {
      type = types.enum ["none" "grub" "systemd-boot"];
      default = "none";
      description = "The bootloader that should be used for the device.";
    };

    device = mkOption {
      type = with types; nullOr str;
      default = "nodev";
      description = "The device to install the bootloader to.";
    };

    plymouth = {
      enable = mkEnableOption "plymouth boot splash";
      withThemes = mkEnableOption (mdDoc ''
        Whether or not themes from https://github.com/adi1090x/plymouth-themes
        should be enabled and configured
      '');

      pack = mkOption {
        type = types.enum [1 2 3 4];
        default = 3;
        description = mdDoc "The pack number for the theme to be selected from.";
      };

      theme = mkOption {
        type = types.str;
        default = "hud_3";
        description = mdDoc "The theme name from the selected theme pack";
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
}
