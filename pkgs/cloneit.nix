{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  openssl,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "cloneit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "alok8bb";
    repo = "cloneit";
    rev = version;
    sha256 = "CyR/vdg6xqlxmv8jOXka3JIBhi8zafHiBOL67XLf5KM=";
  };

  cargoSha256 = "zhsFIU7gmP4gR5NhrFslFSvYIXH1fxJLZU8nV67PluQ=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl];

  meta = with lib; {
    mainProgram = "cloneit";
    description = "CLI tool to download specific GitHub directories or files";
    homepage = "https://github.com/alok8bb/cloneit";
    license = licenses.mit;
  };
}
