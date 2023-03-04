{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sys = config.options.modules.system;
in {
  config = {
    services = {
      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${sys.desktop}";
            user = "${sys.username}";
          };
          default_session =
            if (env.autologin.enable)
            then initial_session
            else "";
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
