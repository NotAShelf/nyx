{pkgs ? import <nixpkgs> {}}: let
  # trivial builders
  inherit (pkgs) mkShell writeShellScriptBin;
in
  mkShell {
    buildInputs = with pkgs; [
      nodejs-slim

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
