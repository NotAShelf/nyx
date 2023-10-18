{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs;
in {
  config = lib.mkIf cfg.gaming.chess.enable {
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
