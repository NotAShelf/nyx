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
    coreutils
    gawk
    procps
    ripgrep
    brightnessctl
    libnotify
    slurp
    sysstat
    (python3.withPackages (ps: [ps.requests]))
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
    # this is an IFD that needs pinning e.g. in system.dependencies
    # but home-manager doesn't have a way of pinning IFDs that I know of
    # YOLO
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

        # runtime
        RuntimeDirectory = "ags";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        CacheDirectory = ["ags"];
        ReadWritePaths = [
          # /run/user/1000 for the socket
          "%t"
          "/tmp/hypr"
        ];

        # restart on failure
        Restart = "on-failure";
        KillMode = "mixed";
      };
    };
  };
}
