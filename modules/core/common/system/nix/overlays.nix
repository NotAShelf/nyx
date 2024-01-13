{inputs', ...}: {
  nixpkgs.overlays = [
    (_: _: {
      nixSuper = inputs'.nix-super.packages.default;
      nixSchemas = inputs'.nixSchemas.packages.default;
    })
  ];
}
