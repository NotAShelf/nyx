{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
  prg = osConfig.modules.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && env.isWayland)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
