{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.modules.system.programs;
in {
  config = mkIf cfg.gaming.chess.enable {
    home.packages = with pkgs; [
      knights
      fairymax
      gnome.gnome-chess
      stockfish
      fishnet
      uchess
    ];
  };
}
