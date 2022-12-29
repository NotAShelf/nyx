{
  config,
  lib,
  ...
}: {
  services = {
    # Input settings for libinput
    xserver.libinput = {
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

    # Enable the TLP daemon for laptop power management.
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 85;
        PCIE_ASPM_ON_BAT = "power$MODsave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        NMI_WATCHDOG = 0;
      };
    };

    # DBus service that provides power management support to applications.
    upower.enable = true;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  hardware.acpilight.enable = true;
  environment.systemPackages = [config.boot.kernelPackages.cpupower];
}
