{
  config,
  pkgs,
  lib,
  ...
}: {
  # Set required env variables from hyprland's wiki
  config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      withJava = true;
      extraPkgs = pkgs:
        with pkgs; [
          libgdiplus
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.Libxinerama
          xorg.libXScrnSaver
        ];
      extraProfile = "export GDK_SCALE=2";
    };
  };
}
