{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.modules.system.programs = mkIf config.modules.profiles.gaming.enable {
    steam.enable = true;
    gaming.enable = true;
  };
}
