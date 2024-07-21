{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) listOf package;
  inherit (config.meta) isWayland;

  mkPackageModuleFor = variant: {
    enable = mkEnableOption "${variant} package sets";
    wayland.enable = mkEnableOption "Wayland package sets" // {default = isWayland;};
    extraPackages = mkOption {
      type = listOf package;
      default = {};
      description = "Extra ${variant} packages to install";
    };
  };
in {
  options.modules.usrEnv.packages = {
    dev.enable = mkEnableOption "development related package sets";

    gui = mkPackageModuleFor "GUI";
    cli = mkPackageModuleFor "CLI";
  };
}
