{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "nixos-wallpapers";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "notashelf";
    repo = "wallpapers";
    rev = version;
    sha256 = "sha256-E/cUxa/GNt/01EjuuvurHxJu3qV9e+jcdcCi2+NxVDA=";
  };

  meta = with lib; {
    description = "A collection of my wallpapers";
    homepage = "https://github.com/notashelf/wallpapers";
    platforms = platforms.linux;
    maintainers = ["notashelf"];
  };
}
