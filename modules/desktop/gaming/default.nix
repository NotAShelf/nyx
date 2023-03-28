{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./gamemode.nix
    ./chess.nix
  ];
}
