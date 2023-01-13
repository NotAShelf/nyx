{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./common.nix
    ./server.nix
  ];
}
