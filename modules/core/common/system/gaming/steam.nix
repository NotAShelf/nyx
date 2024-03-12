{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.modules.system.programs;
in {
  config = lib.mkIf cfg.gaming.enable {
    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-runtime"
          ];
      };

      overlays = [
        (_: prev: {
          steam = prev.steam.override ({extraPkgs ? _: [], ...}: {
            extraPkgs = pkgs':
              (extraPkgs pkgs')
              ++ (with pkgs'; [
                # Add missing dependencies
                libgdiplus
                keyutils
                libkrb5
                libpng
                libpulseaudio
                libvorbis
                stdenv.cc.cc.lib
                xorg.libXcursor
                xorg.libXi
                xorg.libXinerama
                xorg.libXScrnSaver
                at-spi2-atk
                fmodex
                gtk3
                gtk3-x11
                harfbuzz
                icu
                glxinfo
                inetutils
                libthai
                mono5
                pango
                stdenv.cc.cc.lib
                strace
                zlib
                libunwind # for titanfall 2 Northstar launcher
              ]);
          });
        })
      ];
    };

    programs.steam = {
      # enable steam
      enable = true;

      # Open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;

      # Open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;

      # Compatibility tools to install
      extraCompatPackages = [
        inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      ];
    };
  };
}
