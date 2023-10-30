{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules = {
    programs.override = {
      # override basic desktop applications
      # an example override for the libreoffice program
      # if set to true, libreoffice module will not be enabled as it is by default
      libreoffice = mkEnableOption "Override Libreoffice suite";
    };
  };
}
