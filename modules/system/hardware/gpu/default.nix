{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./intel
    ./nvidia
    ./amd
  ];
}
