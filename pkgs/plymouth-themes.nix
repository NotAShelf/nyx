{
  lib,
  stdenv,
  fetchFromGitHub,
  pack ? 2,
  theme ? "green_blocks",
  ...
}:
stdenv.mkDerivation rec {
  pname = "plymouth-themes";
  version = "1.0.0";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "plymouth-themes";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
    sha256 = "sha256-VNGvA8ujwjpC2rTVZKrXni2GjfiZk7AgAn4ZB4Baj2k=";
  };

  configurePhase = ''
    runHook preConfigure
    mkdir -p $out/share/plymouth/themes
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    cp -r ./pack_${toString pack}/${theme} $out/share/plymouth/themes
    sed -i 's;/usr/share;${placeholder "out"}/share;g' \
      $out/share/plymouth/themes/${theme}/${theme}.plymouth
    runHook postInstall
  '';

  meta = {
    description = "A collection of plymouth themes ported from Android.";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
