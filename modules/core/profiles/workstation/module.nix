{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config.modules.usrEnv.programs = mkIf config.modules.profiles.workstation.enable {
    webcord.enable = true;
    element.enable = true;
    libreoffice.enable = true;
    firefox.enable = true;
    thunderbird.enable = true;
    zathura.enable = true;
  };
}
