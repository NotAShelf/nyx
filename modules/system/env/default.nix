{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  device = config.modules.env;
in {
  config = mkMerge [
    (mkIf (device.env == "wayland") {
      # TODO
    })

    (mkIf (device.env == "xorg") {
      # TODOq
    })
  ];
}
