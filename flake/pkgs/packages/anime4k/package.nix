{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "anime4k";
  version = "4.0.1";

  src = fetchzip {
    url = "https://github.com/bloc97/Anime4K/releases/download/v${finalAttrs.version}/Anime4K_v4.0.zip";
    stripRoot = false;
    sha256 = "18x5q7zvkf5l0b2phh70ky6m99fx1pi6mhza4041b5hml7w987pl";
  };

  installPhase = ''
    mkdir $out
    cp *.glsl $out
  '';

  meta = {
    description = "A High-Quality Real Time Upscaler for Anime Video";
    homepage = "https://github.com/bloc97/Anime4K";
    license = lib.licenses.mit;
  };
})
