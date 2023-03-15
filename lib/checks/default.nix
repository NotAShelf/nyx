{pkgs, ...}: {
  alejandra = pkgs.callPackage ./alejandra.nix {};
  statix = pkgs.callPackage ./statix.nix {};
}
