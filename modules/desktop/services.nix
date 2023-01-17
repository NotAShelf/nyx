{
  config,
  pkgs,
  lib,
  ...
}: {
  location.provider = "geoclue2";

  hardware.bluetooth = {
    enable = false;
    package = pkgs.blues5-experimental;
    #hsphfpd.enable = true;
  };

  services = {
    # enable GVfs, a userspace virtual filesystem.
    gvfs.enable = true;

    # thumbnail support on thunar
    tumbler.enable = true;

    # storage daemon required for udiskie auto-mount
    udisks2.enable = true;

    # enable cups and add some drivers for common printers
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
      ];
    };

    # required for network discovery of printers
    avahi = {
      enable = true;
      # resolve .local domains for printers
      nssmdns = true;
    };

    # systemd DNS resolver daemon
    #resolved.enable = true;

    dbus = {
      packages = with pkgs; [dconf gcr udisks2];
      enable = true;
    };

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];

    # https://nixos.wiki/wiki/Bluetooth
    blueman.enable = config.hardware.bluetooth.enable;

    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    # Replace legacy PulseAudio with new and incredibly based PipeWire
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    gnome = {
      evolution-data-server.enable = true;
      # optional to use google/nextcloud calendar
      gnome-online-accounts.enable = true;
      # optional to use google/nextcloud calendar
      gnome-keyring.enable = true;
      # hard fails rebuilds for whatever reason, PLEASE stay disabled
      gnome-remote-desktop.enable = lib.mkForce false;
    };

    cron = {
      enable = true;
      systemCronJobs = with pkgs; [
        "*/5 * * * *      notashelf    ${libnotify}/bin/notify-send \"Health\" \"Look away from the screen for 20 seconds\" -i ${''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#f4b8e4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-heart"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>''} "
      ];
    };
  };
  systemd.user.services = {
    pipewire.wantedBy = ["default.target"];
    pipewire-pulse.wantedBy = ["default.target"];
  };
}
