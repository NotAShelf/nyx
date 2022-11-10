self: super: {
  discord-openasar = import ./discord super;
  plymouth-theme = super.callPackage ./plymouth-theme;
}
