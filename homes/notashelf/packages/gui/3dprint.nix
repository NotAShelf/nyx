{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;

  device = osConfig.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((programs.gui.enable) && (builtins.elem device.type acceptedTypes)) {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
