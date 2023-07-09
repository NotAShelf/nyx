{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib; let
  env = osConfig.modules.usrEnv;
  sys = osConfig.modules.system;
  programs = osConfig.modules.programs;
in {
  config = mkIf (programs.gui.enable && (sys.video.enable && env.isWayland)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
