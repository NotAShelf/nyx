{
  emptyDirectory,
  stdenvNoCC,
  pandoc,
  runCommandLocal,
  sassc,
  configMD,
  outName ? "nyxos-manual.html",
  ...
}: let
  css = runCommandLocal "compile-css" {} ''
    mkdir -p $out
    ${sassc}/bin/sassc -t expanded ${./style.scss} > $out/style.css
  '';
in
  stdenvNoCC.mkDerivation {
    name = "nyxos";
    src = emptyDirectory;

    nativeBuildInputs = [pandoc];

    preBuild = ''
    '';

    buildPhase = ''
      runHook preBuild



      pandoc --verbose \
        --css=${css + /style.css} \
        --from commonmark \
        --to html \
        --toc --standalone ${configMD} \
        --output ${outName}


      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm444 ${outName} $out
      runHook postInstall
    '';
  }
