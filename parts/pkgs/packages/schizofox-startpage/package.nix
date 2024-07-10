{
  lib,
  stdenvNoCC,
}: let
  name = "schizofox-startpage";
  version = "0-2024-07-10-unstable";
in
  stdenvNoCC.mkDerivation {
    inherit name version;
    src = builtins.path {
      path = ./src;
      name = "${name}-${version}";
    };

    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -rv ./* $out
      runHook postInstall
    '';

    meta = {
      description = "My personal startpage";
      license = lib.licenses.gpl3Only;
      maintainers = [lib.maintainers.NotAShelf];
    };
  }
