{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.system.printing = {
    # should the device enable printing module and try to load common printer modules
    # you might need to add more drivers to the printing module for your printer to work
    # regular printing
    enable = mkEnableOption "printing";
    drivers = mkOption {
      type = with types; listOf str;
      default = [];
      description = "A list of drivers to install for printing";
    };

    # 3d printing
    "3d" = {
      enable = mkEnableOption "3D printing suite";
      packages = mkOption {
        type = with types; listOf package;
        default = [];
        description = "A list of packages to install for 3D printing";
      };
    };
  };
}
