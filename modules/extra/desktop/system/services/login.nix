{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  env = config.modules.usrEnv;
  sys = config.modules.system;
  /*
  sessionData = config.services.xserver.displayManager.sessionData.desktops;
  sessionPath = lib.concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
  */
in {
  config = {
    # unlock GPG keyring on login
    security.pam.services = {
      login = {
        enableGnomeKeyring = true;
      };

      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
    };

    services = {
      greetd = {
        enable = true;
        vt = 2;
        restart = !env.autologin;
        settings = {
          # pick up desktop variant (i.e Hyprland) and username from usrEnv
          # this option is usually defined in host/<hostname>/system.nix
          initial_session = mkIf env.autologin {
            command = "${env.desktop}";
            user = "${sys.username}";
          };

          default_session =
            if (!env.autologin)
            then {
              command = lib.concatStringsSep " " [
                (lib.getExe pkgs.greetd.tuigreet)
                "--time"
                "--remember"
                "--remember-user-session"
                "--asterisks"
                # "--power-shutdown '${pkgs.systemd}/bin/systemctl shutdown'"
                #"--sessions '${sessionPath}'"
              ];
              user = "greeter";
            }
            else {
              command = "${env.desktop}";
              user = "${sys.username}";
            };
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
