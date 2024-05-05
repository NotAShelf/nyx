{
  perSystem = {
    config,
    pkgs,
    lib,
    ...
  }: {
    overlayAttrs = config.packages;
    packages = lib.packagesFromDirectoryRecursive {
      inherit (pkgs) callPackage;
      directory = ./packages;
    };
  };
}
