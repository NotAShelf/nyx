{
  lib,
  stdenvNoCC,
}: let
  name = "schizofox-startpage";
  version = "2023-12-29-unstable";
in
  stdenvNoCC.mkDerivation {
    inherit name version;
    src = ./src;

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -rv $src/* $out
      runHook postInstall
    '';

    meta = {
      description = "My personal startpage";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [NotAShelf];
    };
  }
