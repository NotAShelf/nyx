{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  dev = config.modules.device;
in {
  config = mkIf (dev.type != "server") {
    environment.systemPackages = [pkgs.appimage-run];

    # run appimages with appimage-run
    boot.binfmt.registrations = lib.genAttrs ["appimage" "AppImage"] (ext: {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
      magicOrExtension = "\\x7fELF....AI\\x02";
    });

    # run unpatched linux binaries with nix-ld
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        openssl
        curl
        glib
        util-linux
        glibc
        icu
        libunwind
        libuuid
        zlib
        libsecret
        # graphical
        freetype
        libglvnd
        libnotify
        SDL2
        vulkan-loader
        gdk-pixbuf
        xorg.libX11
      ];
    };
  };
}
