{pkgs, ...}: {
  environment.systemPackages = with pkgs; [knights gnome.gnome-chess stockfish uchess];
}
