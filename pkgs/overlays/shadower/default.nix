{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  freetype,
  fontconfig,
  ...
}:
stdenv.mkDerivation rec {
  pname = "shadower";
  version = "0.1.4";
  src = fetchurl {
    url = "https://github.com/n3oney/shadower/releases/download/v${version}/shadower";
    hash = "sha256-gOweqLGYOGbkkVMNjotEV0XI7tIb2w/IJOR5PhSoIb0=";
  };
  dontUnpack = true;
  dontBuild = true;
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [freetype fontconfig stdenv.cc.cc];

  cargoSha256 = "+kg8QMaKcmSVlhIAG7/KAGkh44FAD1o7/x1GL4LWpYc=";
  buildType = "release";
  doCheck = false; # Fails to connect to socket during build

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -vL $src $out/bin/shadower
    chmod +x $out/bin/shadower
    runHook postInstall
  '';
}
