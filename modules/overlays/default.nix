self: super: {
  discord- = import ./discord super;
  plymouth-themes = super.callPackage ../pkgs/plymouth-themes.nix {};
}
