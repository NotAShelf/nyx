{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  wayland,
  wayland-protocols,
  wayland-scanner,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "wl-clip-persist";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = pname;
    rev = "6ba11a2aa295d780f0b2e8f005cf176601d153b0";
    sha256 = "wg4xEXLAZpWflFejP7ob4cnmRvo9d/0dL9hceG+RUr0=";
  };

  cargoSha256 = "OpqaUkWMs3xiAs84aawSTjvMf3Afk1kNYmf9PBPVw5I=";

  nativeBuildInputs = [pkg-config];

  buildInputs = [openssl pkg-config wayland wayland-protocols wayland-scanner];

  meta = with lib; {
    mainProgram = "wl-clip-persist";
    description = "Keep Wayland clipboard even after programs close.";
    homepage = "https://github.com/Linus789/wl-clip-persist";
    license = licenses.mit;
  };
}
