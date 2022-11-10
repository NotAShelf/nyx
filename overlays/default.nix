self: super: {
  discord-oa = import ./discord super;
  plymouth-theme = super.callPackage ./plymouth-theme;
  emacs-ov = super.callPackage ./emacs;
}
