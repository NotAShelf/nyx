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
      enable = true;
      package = pkgs.bluez5-experimental;
      #hsphfpd.enable = true;
    };

    # https://nixos.wiki/wiki/Bluetooth
    services.blueman.enable = true;
  };
}
