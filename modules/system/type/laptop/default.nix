{
  config,
  lib,
  pkgs,
  ...
} @ args:
with lib; let
  device = config.modules.device;
in {
  config = mkIf (device.type == "laptop" || device.type == "hybrid") {
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
          PCIE_ASPM_ON_BAT = "powersupersave";
          DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          NMI_WATCHDOG = 0;
        };
      };

      # TODO: move android adb rule elsewhere
      udev.extraRules = let
        inherit (import ./plugged.nix args) plugged unplugged;
      in ''
        # add my android device to adbusers
        # SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"

        # start/stop services on power (un)plug
        SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${plugged}"
        SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${unplugged}"
      '';

      # DBus service that provides power management support to applications.
      upower.enable = true;
    };

    /*
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    */

    hardware.acpilight.enable = true;
    environment.systemPackages = [
      config.boot.kernelPackages.cpupower
      pkgs.acpi
    ];
  };
}
