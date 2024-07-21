{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (config.meta) isWayland;

  mkPackageModuleFor = variant: {
    enable = mkEnableOption "${variant} package sets";
    wayland.enable = mkEnableOption "Wayland package sets" // {default = isWayland;};
  };
in {
  options.modules.usrEnv.packages = {
    dev.enable = mkEnableOption "development related package sets";

    gui = mkPackageModuleFor "GUI";
    cli = mkPackageModuleFor "CLI";
  };
}
