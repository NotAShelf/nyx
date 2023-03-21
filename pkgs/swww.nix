{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  lz4,
  lib,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "v0.7.2";
  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = version;
    sha256 = "";
  };

  cargoSha256 = "sha256-78Gvabdt/pXHXRNiJELkfzY5z7seZvVn3ogRRG9pflc=";
  buildType = "release";
  doCheck = false; # Fails to connect to socket during build

  nativeBuildInputs = [pkg-config];

  buildInputs = [libxkbcommon lz4];
}
