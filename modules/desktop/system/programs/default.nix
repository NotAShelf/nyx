{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./flatpak
    ./xdg-ninja

    ./cli.nix
    ./gui.nix
  ];
}
