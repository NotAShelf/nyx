{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  sys = config.modules.system.bluetooth;
in {
  config = mkIf (sys.enable) {
    modules.system.boot.extraKernelParams = ["btusb"];

    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      #hsphfpd.enable = true;
      powerOnBoot = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    # https://nixos.wiki/wiki/Bluetooth
    services.blueman.enable = true;
  };
}
