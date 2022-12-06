final: prev: {
  #package-name = prev.callPackage ../package-name/default.nix {};
  plymouth-themes = import ./plymouth;
}
