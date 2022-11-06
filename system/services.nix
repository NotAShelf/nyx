{
  config,
  pkgs,
  lib,
  ...
}: {
  # Don't wait for network startup
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a

  #location.provider = "geoclue2";
  #geoclue2 = {
  #  enable = false;
  #  appConfig.gammastep = {
  #    isAllowed = true;
  #    isSystem = false;
  #  };
  #};

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

  services.journald.extraConfig = ''
    SystemMaxUse=50M
    RuntimeMaxUse=10M
  '';

  services = {
    resolved.enable = true;

    gvfs.enable = true;
    gnome = {
      glib-networking.enable = true;
      gnome-keyring.enable = true;
    };

    lorri.enable = true;
    udisks2.enable = true;
    fstrim.enable = true;

    # enable and secure ssh
    openssh = {
      enable = lib.mkDefault true;
      permitRootLogin = "no";
      passwordAuthentication = true;
    };


    btrfs.autoScrub.enable = true;

    upower.enable = true;
  };
}
