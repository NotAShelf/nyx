{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  device = config.modules.device;
in {
  imports = [
    ./intel
    ./nvidia
    ./amd
  ];
}
