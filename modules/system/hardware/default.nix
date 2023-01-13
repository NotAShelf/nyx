{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cpu
    ./gpu
  ];
}
