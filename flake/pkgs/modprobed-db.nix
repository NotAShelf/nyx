{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libevdev,
  kmod,
  sudo,
  withSudo ? false,
}:
stdenv.mkDerivation rec {
  pname = "modprobed-db";
  version = "2.44";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-APvA96NoYPtUyuzqGWCqOpB73Vz3qhkMvHWExHXhkKM=";
  };

  nativeBuildInputs = [pkg-config];

  buildInputs =
    [kmod libevdev]
    ++ lib.optional withSudo sudo;

  postPatch = ''
    substituteInPlace ./common/modprobed-db.in --replace "/usr/share" "$out/share"
  '';

  installFlags = ["DESTDIR=$(out)" "PREFIX="];

  meta = {
    homepage = "https://github.com/graysky2/modprobed-db";
    description = "useful utility for users wishing to build a minimal kernel via a make localmodconfig";
    longDescription = ''
      Keeps track of EVERY kernel module that has ever been probed.

      Useful for those of us who make localmodconfig :)'';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [NotAShelf];
    platforms = lib.platforms.linux;
  };
}
