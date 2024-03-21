{pkgs ? import <nixpkgs> {}}: let
  # trivial builders
  inherit (pkgs) mkShell writeShellScriptBin;
in
  mkShell {
    buildInputs = with pkgs; [
      nodejs-slim
      # python3 w/ requests is necessary for weather data fetch
      # ags actually doesn't start without it since it's stored
      # as a variable
      (python3.withPackages (ps: [ps.requests]))

      # while developing locally, you need types and other eslint deps
      # so that our eslint config works properly
      # pnpm is used to fetch the deps from package.json
      nodePackages.pnpm

      # dart-sass is for compiling the stylesheets
      dart-sass
      (writeShellScriptBin "compile-stylesheet" ''
        # compile scss files
        ${dart-sass}/bin/sass --verbose \
          --style compressed \
          --no-source-map --fatal-deprecation --future-deprecation \
          ./style/main.scss > ./style.css
      '')
    ];
  }
