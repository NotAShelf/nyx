{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./amd
    ./intel
  ];
}
