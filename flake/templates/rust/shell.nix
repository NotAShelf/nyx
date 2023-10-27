{
  callPackage,
  rust-analyzer,
  rustfmt,
  clippy,
  cargo,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        # Additional rust tooling
        rust-analyzer
        rustfmt
        clippy
        cargo
      ]
      ++ (oa.nativeBuildInputs or []);
  })
