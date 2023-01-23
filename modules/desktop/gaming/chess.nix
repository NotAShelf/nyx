{pkgs, ...}: {
  config = {
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
