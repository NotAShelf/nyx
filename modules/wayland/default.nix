{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  sys = config.modules.system;
in {
  config = mkIf (cfg.enable) (mkMerge [
    /*
    {
      hardware = {
        opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
      };
    }
    */

    (lib.mkIf (sys.isWayland) {
      imports = [
        ./environment.nix
        ./portals.nix
        ./services.nix
      ];
    })
  ]);
}
