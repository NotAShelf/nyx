{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && sys.printing."3d".enable) {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
