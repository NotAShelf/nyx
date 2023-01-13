{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./amd
    ./intel
  ];
}
