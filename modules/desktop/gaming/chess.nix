{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs;
  device = config.modules.device;
  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf ((cfg.gaming.enable && cfg.gaming.chess) && (builtins.elem device.type acceptedTypes)) {
    environment.systemPackages = with pkgs; [
      knights
      fairymax
      gnome.gnome-chess
      stockfish
      fishnet
      uchess
    ];
  };
}
