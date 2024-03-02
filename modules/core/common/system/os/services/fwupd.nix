{config, ...}: {
  # firmware updater for machine hardware
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;

    # newer hardware may have their firmware in testing
    # e.g. Framework devices don't have their firmware in stable yet
    # TODO: make a system-level option that sets this value for hosts
    # that have testing firmware
    # extraRemotes = [ "lvfs-testing" ];
  };
}
