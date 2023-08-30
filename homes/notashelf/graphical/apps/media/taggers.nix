{
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  inherit (osConfig.modules) device;
  acceptedTypes = ["laptop" "desktop" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs; [
      cantata
      easytag
      kid3
    ];
  };
}
