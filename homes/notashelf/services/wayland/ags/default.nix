{
  inputs,
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    config.programs.foot.package
    inputs.hyprpicker.packages.${pkgs.system}.default
    (python3.withPackages (pythonPackages: [pythonPackages.requests]))
    # basic functionality
    sassc
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
    # desktop items
    pavucontrol
    networkmanagerapplet
    blueman
  ];

  fs = lib.fileset;
  filterNixFiles = fs.fileFilter (file: lib.hasSuffix ".nix" file.name) ./.;
  baseSrc = fs.unions [
    ./js
    ./scss
    ./config.js
    ./style.css
  ];

  filter = fs.difference baseSrc filterNixFiles;

  cfg = config.programs.ags;

  inherit (lib) mkIf;
  inherit (osConfig.modules) device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  imports = [inputs.ags.homeManagerModules.default];
  config = mkIf (builtins.elem device.type acceptedTypes) {
    programs.ags = {
      enable = true;
      configDir = fs.toSource {
        root = ./.;
        fileset = filter;
      };
    };

    systemd.user.services.ags = {
      Unit = {
        Description = "Aylur's Gtk Shell (Ags)";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];

        After = ["graphical-session-pre.target"];
      };

      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/ags";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
