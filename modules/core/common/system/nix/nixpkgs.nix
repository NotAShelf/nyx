{inputs', ...}: {
  # Global nixpkgs configuration. This is ignored if nixpkgs.pkgs is set
  # which is a case that should be avoided. Everything that is set to configure
  # nixpkgs must go here.
  nixpkgs = {
    # Configuration reference:
    # <https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig>
    config = {
      allowBroken = false;
      allowUnsupportedSystem = true;

      # Really a pain in the ass to deal with when disabled. True means
      # we are able to build unfree packages without explicitly allowing
      # each unfree package.
      allowUnfree = true;

      # Default to none, add more as necessary. This is usually where
      # electron packages go when they reach EOL.
      permittedInsecurePackages = [];

      # Disable the usage of nixpkgs aliases in the configuration.
      allowAliases = false;

      # Enable parallel building by default.
      enableParallelBuildingByDefault = true;

      # List of derivation warnings to display while rebuilding.
      # See: <https://github.com/NixOS/nixpkgs/blob/master/pkgs/stdenv/generic/check-meta.nix>
      showDerivationWarnings = ["maintainerless"];
    };

    overlays = [
      (_: _: {
        nixSuper = inputs'.nix-super.packages.default;
        nixSchemas = inputs'.nixSchemas.packages.default;
      })
    ];
  };
}
