final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  fastfetch = prev.callPackage ./fastfetch {};
  ani-cli = prev.callPackage ./ani-cli {};
  mov-cli = prev.callPackage ./mov-cli {};
  anime4k = prev.callPackage ./anime4k {};
  spotify-wrapped = prev.callPackage ./spotify-wrapped {};
  cloneit = prev.callPackage ../cloneit.nix {};
}
