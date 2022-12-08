{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  lz4,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = version;
    sha256 = lib.fakeSha256;
  };

  cargoLock.lockFile = ./Cargo.lock;
  #cargoSha256 = lib.fakeSha256;
  buildType = "release";
  doCheck = false; # Fails to connect to socket during build

  nativeBuildInputs = [pkg-config];

  buildInputs = [libxkbcommon lz4];
}
