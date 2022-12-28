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
  version = "v0.6.0";
  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = version;
    sha256 = "sha256-9qTKaLfVeZD8tli7gqGa6gr1a2ptQRj4sf1XSPORo1s=";
  };

  cargoSha256 = "sha256-78Gvabdt/pXHXRNiJELkfzY5z7seZvVn3ogRRG9pflc=";
  buildType = "release";
  doCheck = false; # Fails to connect to socket during build

  nativeBuildInputs = [pkg-config];

  buildInputs = [libxkbcommon lz4];
}
