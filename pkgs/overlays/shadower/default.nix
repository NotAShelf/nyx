{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  lz4,
  python3,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "shadower";
  version = "v0.1.4";
  src = fetchFromGitHub {
    owner = "n3oney";
    repo = pname;
    rev = version;
    sha256 = "kmd+TqfDKL7bmu0fiLbjPoVOsn4Mcsb0REya0Me3Ias=";
  };

  cargoSha256 = "+kg8QMaKcmSVlhIAG7/KAGkh44FAD1o7/x1GL4LWpYc=";
  buildType = "release";
  doCheck = false; # Fails to connect to socket during build

  nativeBuildInputs = [pkg-config];

  buildInputs = [libxkbcommon lz4 python3];
}
