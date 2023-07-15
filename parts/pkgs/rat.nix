{
  stdenv,
  fetchurl,
  gnused,
  makeWrapper,
  pkgs,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "rat";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/Mcharlsto/rat/releases/download/${version}/rat";
    sha256 = "sha256-93sspjvXFPocGFPeCF1AWoWYx5hI7vMltx9SQ7x25z4=";
  };

  buildInputs = [gnused makeWrapper];

  phases = ["installPhase" "postInstall"];

  installPhase = ''
    mkdir -p $out/bin

    cp $src $out/bin/rat

    chmod +x $out/bin/rat

    sed -i '1 s/^.*$/#\/usr\/bin\/env bash/' $out/bin/rat
  '';

  postInstall = ''
    wrapProgram $out/bin/rat \
      --prefix PATH : ${lib.makeBinPath (with pkgs; [sharutils opusfile sox bash])}
  '';
}
