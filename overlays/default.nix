final: prev: {
  #package-name = prev.callPackage ../package-name/default.nix {};
  plymouth-themes = prev.callPackage ./plymouth/default.nix {};
}
