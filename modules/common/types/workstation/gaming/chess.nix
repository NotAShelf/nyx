{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.modules.usrEnv.programs.gaming.chess.enable {
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
