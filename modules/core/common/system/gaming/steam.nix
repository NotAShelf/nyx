{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  prg = config.modules.system.programs;
in {
  config = mkIf prg.gaming.steam.enable {
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
            extraProfile = "export SDL_VIDEODRIVER=x11";
            extraPkgs = pkgs':
              (extraPkgs pkgs')
              # Add missing dependencies
              ++ (with pkgs'; [
                # Generic dependencies
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

                # for Titanfall 2 Northstar launcher
                libunwind
              ]);
          });
        })
      ];
    };

    programs.steam = {
      # Enable steam
      enable = true;

      # Whether to open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;

      # Whether to open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;

      # Compatibility tools to install
      # For the accepted format (and the reason behind)
      # the "compattool" attribute, see:
      # <https://github.com/NixOS/nixpkgs/pull/296009>
      extraCompatPackages = [
        pkgs.proton-ge-bin.steamcompattool
      ];
    };
  };
}
