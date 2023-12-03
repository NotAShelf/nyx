{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    bash
    coreutils
    gawk
    inotify-tools
    procps
    ripgrep
    sassc
    gtk3
    brightnessctl
    komikku
  ];

  fs = pkgs.lib.fileset;
  baseSrc = fs.unions [
    ./config.js
    ./imports.js
    ./style.css
    ./modules
    ./scripts
    ./scss
    ./services
    ./utils
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
      Unit = {
        Description = "Aylur's Gtk Shell";
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
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
