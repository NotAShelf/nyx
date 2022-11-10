self: super: {
  discord-openasar = import ./discord super;
  #plymouth-themes = super.callPackage ./plymouth { };
}
