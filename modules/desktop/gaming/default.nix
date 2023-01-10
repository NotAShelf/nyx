{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./steam.nix
    ./gamemode.nix
  ];
}
