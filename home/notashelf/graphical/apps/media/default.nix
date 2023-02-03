{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  imports = [
    ./mpv.nix
    ./packages.nix
  ];
}
