{
  config,
  pkgs,
  ...
}: {
  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    services.NetworkManager-wait-online.enable = false;
  };

  location.provider = "geoclue2";

  programs.dconf.enable = true;

  services = {
    dbus = {
      enable = true;
      packages = [pkgs.dconf pkgs.gcr];
    };

    printing.enable = true;
    resolved.enable = true;

    udisks2.enable = true;
    fstrim.enable = true;

    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "notashelf";
        };
        default_session = initial_session;
      };
    };

    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        HibernateDelaySec=3600
      '';
    };

    btrfs.autoScrub.enable = true;
    upower.enable = true;

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
  };
}
