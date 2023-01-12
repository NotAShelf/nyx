{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    knights
    gnome.gnome-chess
    stockfish
    fishnet
    uchess
    xboard
    arena
  ];
}
