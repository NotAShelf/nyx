{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && env.isWayland)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
