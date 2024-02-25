{lib, ...}: {
  # This enables non-free firmware on devices not recognized by `nixos-generate-config`.
  # Disabling this option will make the system unbootable if such devices are critical
  # in your boot chain - therefore this should remain true until you are running a device
  # with mostly libre firmware. Which there is not many of.
  # on 2021-06-14: disabled this by accident and nuked my GPU drivers
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
