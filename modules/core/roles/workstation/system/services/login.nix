{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
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
    security.pam.services = let
      gnupg = {
        enable = true;
        noAutostart = true;
        storeOnly = true;
      };
    in {
      login = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };

      greetd = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };

      tuigreet = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };
    };

    services = {
      xserver.displayManager = {
        startx.enable = true;
        session = [
          (mkIf env.desktops.i3.enable {
            name = "i3wm";
            manage = "desktop";
            start = ''
              ${pkgs.xorg.xinit}/bin/startx ${pkgs.i3-rounded}/bin/i3 -- vt2 &
              waitPID=$!
            '';
          })
        ];
      };

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
