{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = lib.mkIf ((osConfig.modules.programs.gui.enable && osConfig.modules.system.printing."3d".enable) && (lib.isAcceptedDevice osConfig acceptedTypes)) {
    home.packages = with pkgs; [
      freecad
      prusa-slicer
    ];
  };
}
