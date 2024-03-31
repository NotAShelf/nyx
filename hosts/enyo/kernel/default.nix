{pkgs, ...}: let
  inherit (pkgs.callPackage ./package.nix {}) xanmod_custom;
in {
  imports = [./config];
  config = {
    modules.system.boot.kernel = pkgs.linuxPackagesFor xanmod_custom;
  };
}
