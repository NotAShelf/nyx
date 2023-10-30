{lib, ...}: {
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
              libunwind # for titanfall 2 Northstart launcher
            ]);
        });
      })
    ];
  };
}
