{
  lib,
  makeWrapper,
  rustPlatform,
  pkg-config,
  cargo,
  rustc,
  fetchFromGitHub,
  wayland,
  wayland-scanner,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "waycorner";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "AndreasBackx";
    repo = pname;
    rev = version;
    sha256 = "sha256-xvmvtn6dMqt8kUwvn5d5Nl1V84kz1eWa9BSIN/ONkSQ=";
  };

  cargoSha256 = "sha256-Dl+GhJywWhaC4QMS70klazPsFipGVRW+6jrXH2XsEAI=";

  buildInputs = [
    rustc
    cargo
    wayland
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    makeWrapper
  ];

  postFixup = ''
    # the program looks for libwayland-client.so at runtime
    wrapProgram $out/bin/waycorner \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [wayland]}
  '';

  RUST_BACKTRACE = "full";

  meta = with lib; {
    description = "Hot corners for Wayland.";
    homepage = "https://github.com/AndreasBackx/waycorner";
    license = with licenses; [mit];
    maintainers = with maintainers; [NotAShelf];
  };
}
