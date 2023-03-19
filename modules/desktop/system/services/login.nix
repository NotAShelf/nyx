{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  env = config.modules.usrEnv;
  sys = config.modules.system;
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
        settings = rec {
          # pick up desktop variant (i.e Hyprland) and username from usrEnv
          # this option is usually defined in host/<hostname>/system.nix
          initial_session = {
            command = "${env.desktop}";
            user = "${sys.username}";
          };
          # default_session should be configured only if autologin is enabled
          default_session =
            if (env.autologin)
            then mkForce initial_session
            else mkForce "";
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
