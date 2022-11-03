{
  lib,
  stdenv,
  fetchzip,
  pkgs,
  ...
}:

rustPlatform.buildRustPackage rec {
  pname = "cloneit";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "alok8bb";
    repo = "cloneit";
    hash = "62c433f0b1c54a977d585f3b84b8c43213095474"; # testing
  };

  meta = {
    description = "A cli tool to download specific GitHub directories or files.";
    homepage = "https://github.com/alok8bb/cloneit";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [lib.maintainers.notashelf];
  };
}
