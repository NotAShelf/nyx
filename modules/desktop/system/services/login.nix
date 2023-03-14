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
    security.pam.services.greetd = {
      gnupg.enable = true;
      enableGnomeKeyring = true;
    };

    services = {
      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${env.desktop}";
            user = "${sys.username}";
          };
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
