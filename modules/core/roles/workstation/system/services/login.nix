{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.meta) getExe;

  env = config.modules.usrEnv;
  sys = config.modules.system;

  # make desktop session paths available to greetd
  sessionData = config.services.xserver.displayManager.sessionData.desktops;
  sessionPaths = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  initialSession = {
    user = "${sys.mainUser}";
    command = "${env.desktop}";
  };

  defaultSession = {
    user = "greeter";
    command = concatStringsSep " " [
      (getExe pkgs.greetd.tuigreet)
      "--time"
      "--remember"
      "--remember-user-session"
      "--asterisks"
      "--sessions '${sessionPaths}'"
    ];
  };
in {
  config = {
    # unlock GPG keyring on login
    security.pam.services = {
      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
    };

    services = {
      xserver.displayManager.session = mkMerge [
        (mkIf env.desktops.i3.enable {
          manage = "desktop";
          name = "i3wm";
          start = ''
            ${pkgs.xorg.xinit}/bin/startx ${lib.getExe pkgs.i3}
          '';
        })
      ];

      greetd = {
        enable = true;
        vt = 2;
        restart = !sys.autoLogin;

        # <https://man.sr.ht/~kennylevinsen/greetd/>
        settings = {
          # default session is what will be used if no session is selected
          # in this case it'll be a TUI greeter
          default_session = defaultSession;

          # initial session
          initial_session = mkIf sys.autoLogin initialSession;
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
