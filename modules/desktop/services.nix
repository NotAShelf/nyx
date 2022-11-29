{
  config,
  pkgs,
  ...
}: {
  location.provider = "geoclue2";

  hardware.bluetooth = {
    enable = false;
    package = pkgs.blues5-experimental;
    hsphfpd.enable = true;
  };

  services = {
    printing.enable = true;
    resolved.enable = true;
    udisks2.enable = true;
    btrfs.autoScrub.enable = true;
    upower.enable = true;

    # https://nixos.wiki/wiki/Bluetooth
    blueman.enable = config.hardware.bluetooth.enable;

    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    # Use pipewire instead of soyaudio
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    # Try to save as much battery as possible
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "power$MODsave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        NMI_WATCHDOG = 0;
      };
    };

    gnome = {
      evolution-data-server.enable = true;
      # optional to use google/nextcloud calendar
      gnome-online-accounts.enable = true;
      # optional to use google/nextcloud calendar
      gnome-keyring.enable = true;
    };
  };
}
