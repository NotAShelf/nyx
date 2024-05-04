{
  callPackage,
  go,
  gopls,
  delve,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        delve
        go
        gopls
      ]
      ++ (oa.nativeBuildInputs or []);
  })
