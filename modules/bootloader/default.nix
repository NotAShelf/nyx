{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
in {
  config = mkMerge [
    (mkIf (device.type == "server") {
      imports = [
        ./server.nix
      ];
    })
    (mkIf (device.type != "server") {
      imports = [
        ./common.nix
      ];
    })
  ];
}
