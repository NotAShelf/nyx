{
  curl,
  p7zip,
  runCommand,
  webcord,
  ...
}: let
  inherit (webcord) src;
  vencord-url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=109.0&x=id%3Dcbghhgpcnddeihccjmnadmkaejncjndb%26installsource%3Dondemand%26uc";

  vencordExtension =
    runCommand "vencord-extension" {
      # I don't know how reproducible the url is...
      VENCORD_CRX_URL = vencord-url;
      sha256 = "";
      outputHash = "lovKwzBa4IMKDZ4TR6lv9pzWV7Vjm1FXG8ZRv4dZ9IM=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      nativeBuildInputs = [curl p7zip];
      downloadToTemp = false;
      patches = [
        ./content-policy.patch
      ];
    } ''
      export TEMP="$(mktemp -d)"
      curl -k "$VENCORD_CRX_URL" -L -o vencord.crx
      mkdir -p "$out"
      7z x vencord.crx -o"$out" -y
      rm -rf "$out/_metadata"
    '';
in
  webcord.overrideAttrs (old: {
    inherit src;
    version = "git";
    patchPhase = ''
      runHook prePatch

      sed -i "361i session.defaultSession.loadExtension(\"${vencordExtension}\").then(() => console.log(\"Vencord loaded.\"));" "sources/code/common/main.ts"

      runHook postPatch
    '';
    npmDeps = old.npmDeps.overrideAttrs (_old: {
      inherit src;
      outputHash = "sha256-PeoOoEljbkHynjZwocCWCTyYvIvSE1gQiABUzIiXEdM=";
    });
  })
