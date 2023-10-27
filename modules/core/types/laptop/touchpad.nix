{
  config,
  lib,
  ...
}: let
  device = config.modules.device;
in {
  config = lib.mkIf (device.type == "laptop" || device.type == "hybrid") {
    services = {
      # Input settings for libinput
      xserver.libinput = {
        # enable libinput
        enable = true;

        # disable mouse acceleration
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
          middleEmulation = false;
        };

        # touchpad settings
        touchpad = {
          naturalScrolling = true;
          tapping = true;
          clickMethod = "clickfinger";
          horizontalScrolling = false;
          disableWhileTyping = true;
        };
      };
    };
  };
}
