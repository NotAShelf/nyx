{
  inputs,
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem path;
  inherit (lib.modules) mkIf;
  inherit (osConfig.modules) device;
  inherit (import ./bin {inherit pkgs lib;}) ags-open-window ags-move-window ags-hyprctl-swallow;

  agsPkg = inputs.ags.packages.${pkgs.stdenv.system}.ags;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (elem device.type acceptedTypes) {
    home.packages = [agsPkg];
    systemd.user.services.ags = let
      # dependencies required for the ags runtime to function properly
      # some of those dependencies are used internally for setting variables
      # or basic functionality where built-in services do not suffice
      coreDeps = with pkgs; [
        inputs.hyprpicker.packages.${pkgs.stdenv.system}.default
        inputs.hyprland.packages.${pkgs.stdenv.system}.default
        config.programs.foot.package

        # basic functionality
        inotify-tools
        gtk3

        # script and service helpers
        bash
        brightnessctl
        coreutils
        gawk
        gvfs
        imagemagick
        libnotify
        procps
        ripgrep
        slurp
        sysstat

        # runtime scripts
        ags-open-window
        ags-move-window
        ags-hyprctl-swallow
      ];

      # applications that are not necessarily required to compile ags
      # but are used by the widgets to launch certain applications
      widgetDeps = with pkgs; [
        pavucontrol
        networkmanagerapplet
        blueman
      ];

      dependencies = coreDeps ++ widgetDeps;

      agsSrc = path {
        name = "ags-configuration-src";
        path = ./src;
      };

      agsSource = pkgs.runCommand "build-ags-configuration" {nativeBuildInputs = with pkgs; [bun dart-sass];} ''
        mkdir -p $out

        # Compile stylesheet
        sass --verbose --style=compressed --no-source-map \
          ${agsSrc}/style/main.scss \
          $out/style.css

        # Build the configuration file with Bun
        bun build ${agsSrc}/main.ts \
          --external 'resource://*' \
          --external 'gi://*' \
          --external 'file://*' \
          --public-path ${agsSrc} \
          --target bun \
          --outfile $out/config.js
      '';
    in {
      Install.WantedBy = ["graphical-session.target"];

      Unit = {
        Description = "Aylur's Gtk Shell (Ags)";
        After = ["graphical-session-pre.target"];
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
      };

      Service = {
        Type = "simple";
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = pkgs.writeShellScript "ags-start" ''
          # Use $XDG_RUNTIME_DIR/ags as the configuration directory
          # with compiled configuration and stylesheet files
          ${agsPkg}/bin/ags --config ${agsSource}/config.js
        '';

        # Kill and restart ags on SIGUSR2
        # provides some kind of a hot-reloading functionality
        # which is not *really* necessary, but is there anyway
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";

        # Takes a value between -20 and 19. Higher values (e.g. 19) mean lower priority.
        # Lower priority means the process will get less CPU time and therefore will be slower.
        # Fortunately I do not need my status bar to be fast. Also, the difference is almost
        # unnoticeable, and definitely negligible.
        Nice = 19;

        # Hardening options.
        # Ags is a NodeJS runtime, and is allowed to execute arbitrary JavaScript code.
        # Also in my config, it is allowed to call for Python and Bash scripts.
        # Indeed, this is a security risk, and therefore we must make an effort to reduce
        # this risk by hardening the systemd service as much as possible.
        # See: `man 5 systemd.exec`
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        PrivateUsers = true;
        PrivateDevices = true;

        RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;

        RemoveIPC = true;
        PrivateMounts = true;

        # FIXME: ags cannot start if this is set
        # MemoryDenyWriteExecute = true;
        # CapabilityBoundingSet = "";
        # System Call Filtering
        # SystemCallArchitectures = "native";
        # SystemCallFilter = ["~@clock @process"];

        NoNewPrivileges = true;
        LockPersonality = true;

        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";

        # Runtime access control
        RuntimeDirectory = "ags";
        RuntimeDirectoryMode = "0700";

        CacheDirectory = ["ags"];
        UMask = "0027";
        ReadWritePaths = [
          # Socket and runtime directory access
          # %t refers to $XDG_RUNTIME_DIR
          "%t/hypr"
          "%t/dconf/user"
          "%t/pulse"
          "%t/ags"
          "%t/gvfs"
          "%t/gvfsd"

          # Additional directories required for
          # working with cached files
          "%h/.cache/ags"
          "%h/.local/share/firefox-mpris/"
        ];

        # restart on failure
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };
  };
}
