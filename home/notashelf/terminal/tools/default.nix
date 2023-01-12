{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./nix-index.nix
    ./programs.nix
    ./services.nix
    ./xdg.nix
  ];
}
