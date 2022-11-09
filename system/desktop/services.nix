{
  config,
  pkgs,
  ...
}: {
  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
    user = {
      services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud";
        After = "network-online.target"; 
      };
      Service = {
        Type = "simple";
        ExecStart= "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /music /home/myuser/music https://nextcloud.example.org"; 
        TimeoutStopSec = "180";
        KillMode = "process";
        KillSignal = "SIGINT";
      };
      Install.WantedBy = ["multi-user.target"];
    };
    timers.nextcloud-autosync = {
      Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
      Timer.OnUnitActiveSec = "60min";
      Install.WantedBy = ["multi-user.target" "timers.target"];
    };
    startServices = true;

    }
  };


  location.provider = "geoclue2";

  services = {

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';

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

    syncthing = {
      enable = false;
      openDefaultPorts = true;
      user = "notashelf";
      group = "wheel";
      dataDir = "$HOME/syncthing";
      configDir = "$HOME/.config/syncthing/";
      systemService = true;
    };

    resolved.enable = true;

    # enable and secure ssh
    openssh = {
      enable = false;
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

    printing.enable = true;

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
