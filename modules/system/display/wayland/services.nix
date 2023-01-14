{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.video;
  sys = config.modules.system;
in {
  config = mkIf (cfg.enable && sys.isWayland) {
    systemd.services = {
      seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${getExe pkgs.seatd} -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = ["multi-user.target"];
      };
    };

    services = {
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
    };
  };
}
