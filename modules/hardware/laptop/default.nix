{
  config,
  lib,
  ...
}: {
  services.xserver.libinput = {
    enable = true;
    # disable mouse acceleration
    mouse.accelProfile = "flat";
    mouse.accelSpeed = "0";
    mouse.middleEmulation = false;

    # touchpad settings
    touchpad.naturalScrolling = true;
    touchpad.tapping = true;
    touchpad.clickMethod = "clickfinger";
    touchpad.horizontalScrolling = false;
    touchpad.disableWhileTyping = true;
  };

  services.tlp.enable = lib.mkForce true;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  hardware.acpilight.enable = true;
  environment.systemPackages = [config.boot.kernelPackages.cpupower];
}
