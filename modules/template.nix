{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.PROGRAMNAME;
in {
  options.modules.programs.PROGRAMNAME = {enable = mkEnableOption "PROGRAMNAME";};

  config = mkIf cfg.enable {
    home.packages = [pkgs.PROGRAMNAME];
    home.file.".config/PROGRAMNAME/EXAMPLECONF.conf".text = import ./config.nix;
  };
}
