{
  inputs,
  nixfmt,
  ...
}:
nixfmt.overrideAttrs (self: let
  pname = "nixfmt-rfc";
  version = "${self.version}-${inputs.nixfmt.shortRev}";
in {
  inherit pname version;
  src = inputs.nixfmt;

  patchPhase = ''
    runHook prePatch

    substituteInPlace nixfmt.cabal \
      # this is fucking funny - the revision is ommitted
      # thank you haskell
      --replace 0.5.0 ${version}

    runHook postPatch
  '';
})
