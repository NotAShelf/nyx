{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  config = mkIf (dev.type == "laptop" || dev.type == "hybrid") {
    services = {
      # TODO: move android adb rule elsewhere
      # this should probably be a device or programs option
      udev.extraRules = ''
        # add my android device to adbusers
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"
      '';
    };
  };
}
