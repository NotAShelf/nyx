{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.bluetooth;
in {
  config = mkIf (cfg.enable) {
    hardware.bluetooth = {
      enable = false;
      package = pkgs.blues5-experimental;
      #hsphfpd.enable = true;
    };

    # https://nixos.wiki/wiki/Bluetooth
    services.blueman.enable = config.hardware.bluetooth.enable;
  };
}
