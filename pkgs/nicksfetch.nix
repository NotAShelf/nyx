{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
  pciutils,
  x11Support ? true,
  ueberzug,
  fetchpatch,
}:
stdenvNoCC.mkDerivation rec {
  pname = "nicksfetch";
  version = "unstable-2021-12-10";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "neofetch";
    rev = "ccd5d9f52609bbdcd5d8fa78c4fdb0f12954125f";
    sha256 = "sha256-9MoX6ykqvd2iB0VrZCfhSyhtztMpBTukeKejfAWYW1w=";
  };

  patches = [
    ./patches/nicksfetch.patch
  ];

  outputs = ["out" "man"];

  strictDeps = true;
  buildInputs = [bash];
  nativeBuildInputs = [makeWrapper];
  postPatch = ''
    patchShebangs --host neofetch
  '';

  postInstall = ''
    wrapProgram $out/bin/neofetch \
      --prefix PATH : ${lib.makeBinPath ([pciutils] ++ lib.optional x11Support ueberzug)}
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    description = "A fast, highly customizable system info script";
    homepage = "https://github.com/dylanaraps/neofetch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [alibabzo konimex notashelf];
    mainProgram = "neofetch";
  };
}
