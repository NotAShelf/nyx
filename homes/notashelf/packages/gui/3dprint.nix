{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.programs;
  sys = osConfig.modules.system;

  dev = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((prg.gui.enable && sys.printing."3d".enable) && (builtins.elem dev.type acceptedTypes)) {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
