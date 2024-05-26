{
  inputs,
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.fileset) fileFilter unions difference toSource;
  inherit (lib.modules) mkIf;
  inherit (osConfig.modules) device;

  # dependencies required for the ags runtime to function properly
  # some of those dependencies are used internally for setting variables
  # or basic functionality where built-in services do not suffice
  coreDeps = with pkgs; [
    inputs.hyprpicker.packages.${pkgs.system}.default
    inputs.hyprland.packages.${pkgs.system}.default
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
  ];

  # applications that are not necessarily required to compile ags
  # but are used by the widgets to launch certain applications
  widgetDeps = with pkgs; [
    pavucontrol
    networkmanagerapplet
    blueman
  ];

  dependencies = coreDeps ++ widgetDeps;
  filterNixFiles = fileFilter (file: lib.hasSuffix ".nix" file.name) ./.;

  baseSrc = unions [
    # runtime executables
    ./bin

    # ags widgets and utilities
    ./js
    ./config.js

    # compiled stylesheet
    # should be generated using the below command
    # `sassc -t compressed style/main.scss style.css`
    ./style.css
  ];

  filter = difference baseSrc filterNixFiles;

  cfg = config.programs.ags;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  imports = [inputs.ags.homeManagerModules.default];
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.ags = {
      enable = true;
      configDir = toSource {
        root = ./.;
        fileset = filter;
      };
    };

    systemd.user.services.ags = {
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
        ExecStart = "${cfg.package}/bin/ags";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID"; # hot-reloading

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
          # socket access
          # %t refers to /run/user/<id>
          "%t/hypr"
          "%t/dconf/user"
          "%t/pulse"

          # for thumbnail caching
          "%h/.cache/ags/media"
          "%h/.local/share/firefox-mpris/"
        ];

        # restart on failure
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };
  };
}
