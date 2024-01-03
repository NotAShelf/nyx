{
  stdenv,
  lib,
  makeWrapper,
  box64,
  x64-bash,
  pkg,
  deps,
  bins ? "${lib.getBin pkg}/bin/*",
  entry ? "${box64}/bin/box64",
  extraWrapperArgs ? [],
}:
stdenv.mkDerivation rec {
  name = "box64-wrapped-${pkg.name}";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper];

  buildInputs = deps;

  installPhase = ''
    runHook preInstall

    for bin in ${bins}; do
    	mkdir -p $out/bin
    	makeWrapper ${entry} $out/bin/"$(basename "$bin")" \
    		--set BOX64_BASH ${lib.getBin x64-bash}/bin/bash \
    		--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
    		${lib.strings.concatStringsSep " " extraWrapperArgs}\
    		--add-flags "$bin"
    done

    runHook postInstall
  '';
}
