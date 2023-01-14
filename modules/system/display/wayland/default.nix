{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./environment.nix
    ./portals.nix
    ./services.nix
    ./overlay.nix
  ];
}
