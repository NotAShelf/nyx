self: super: {
  discord-openasar = import ./discord super;
  plymouth-themes = super.callPackage ../pkgs/plymouth-themes.nix {};
}
