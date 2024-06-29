{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config.modules = mkIf config.modules.profiles.gaming.enable {
    system.programs = {
      steam.enable = true;
      gaming.enable = true;
    };

    usrEnv.programs = {
      gaming.enable = true;
      steam.enable = true;
    };
  };
}
