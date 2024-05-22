{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.modules.system.programs = mkIf config.modules.profiles.workstation.enable {
    webcord.enable = true;
    element.enable = true;
    libreoffice.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
    zathura.enable = true;
  };
}
