{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules meta;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && meta.isWayland)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
