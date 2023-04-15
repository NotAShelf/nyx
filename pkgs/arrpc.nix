{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  python3,
  nodejs,
  nixosTests,
}:
buildNpmPackage rec {
  pname = "arRPC";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arRPC";
    rev = "9689f1f21d23d1b0acc2b8572aee2044f650ebb5";
    sha256 = "sha256-r+X2LOgjdMfbhTggI/8JACQSmhJP/asAdOD/kp/AV0I=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-ZgoxPBOxdi/Jd7ZQaow56gZchDHQpXuLJjbvcsy/pqA=";

  nativeBuildInputs = [python3];

  preInstall = ''
    mkdir -p $out/lib/node_modules/arRPC/
  '';

  postInstall = ''
    cp -rf src/* ext/* $out/lib/node_modules/arRPC/
  '';

  postFixup = ''
    ${nodejs}/bin/node --version
    makeWrapper ${nodejs}/bin/node $out/bin/arRPC \
      --add-flags $out/lib/node_modules/arrpc/src \
      --chdir $out/lib/node_modules/arrpc/src
  '';

  passthru.tests.arrpc = nixosTests.arrpc;

  meta = with lib; {
    description = "An open implementation of Discord's local RPC servers";
    homepage = "https://github.com/OpenAsar/arRPC";
    changelog = "https://github.com/OpenAsar/arRPC/blob/main/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [notashelf];
  };
}
