{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    config.programs.foot.package
    inputs.hyprpicker.packages.${pkgs.system}.default
    bash
    coreutils
    gawk
    inotify-tools
    procps
    ripgrep
    sassc
    gtk3
    brightnessctl
    libnotify
    networkmanagerapplet
    slurp
  ];

  fs = lib.fileset;
  baseSrc = fs.unions [
    ./js
    ./scss
    ./config.js
    ./style.css
  ];

  filterNixFiles = fs.fileFilter (file: lib.hasSuffix ".nix" file.name) ./.;
  filter = fs.difference baseSrc filterNixFiles;

  cfg = config.programs.ags;
in {
  imports = [inputs.ags.homeManagerModules.default];
  config = {
    programs.ags = {
      enable = true;
      extraPackages = dependencies;

      configDir = fs.toSource {
        root = ./.;
        fileset = filter;
      };
    };

    systemd.user.services.ags = {
      Install.WantedBy = ["graphical-session.target"];
      Unit = {
        Description = "Aylur's Gtk Shell (Ags)";
        PartOf = [
          "tray.target"
          "graphical-session.target"
        ];
      };

      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/ags";
        Restart = "on-failure";
      };
    };
  };
}
