{
  config,
  pkgs,
  ...
}: 

{
  systemd.services = {
    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  services = {
    syncthing = {
      enable = false;
      openDefaultPorts = true;
      user = "notashelf";
      group = "wheel";
      dataDir = "$HOME/syncthing";
      configDir = "$HOME/.config/syncthing/";
      systemService = true;
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

    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };
    
    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        HibernateDelaySec=3600
      '';
    };

    lorri.enable = true;
    udisks2.enable = true;
    printing.enable = true;
    fstrim.enable = true;

    # enable and secure ssh
    openssh = {
      enable = false;
      permitRootLogin = "no";
      passwordAuthentication = true;
    };

    # Use pipewire instead of soyaudio
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Try to save as much battery as possible
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
        NMI_WATCHDOG = 0;
      };
    };
  };
}
