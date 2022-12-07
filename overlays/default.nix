final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  #nickfetch = prev.callPackage ../pkgs/nicksfetch.nix {};
}
