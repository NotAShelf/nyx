{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) stdenv;

  jdk = pkgs.openjdk17_headless;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "reposilite";
    version = "3.4.10";

    jar = builtins.fetchurl {
      url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${finalAttrs.version}/reposilite-${finalAttrs.version}-all.jar";
      sha256 = "0ca6awmzsmap28l0f65h71i3kfl5jfqr4c19hadixlp5k0s8qppm";
    };

    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = ''
      runHook preInstall
      makeWrapper ${jdk}/bin/java $out/bin/reposilite \
        --add-flags "-Xmx40m -jar $jar" \
        --set JAVA_HOME ${jdk}
      runHook postInstall
    '';

    meta = {
      description = "A lightweight repository manager for Maven artifacts";
      homepage = "https://reposilite.com";
      license = lib.licenses.asl20;
      mainPackage = finalAttrs.pname;
      maintainers = with lib.maintainers; [NotAShelf];
    };
  })
