final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  fastfetch = prev.callPackage ./fastfetch {};
  chromium = prev.callPackage ./chromium {};
  ani-cli = prev.callPackage ./ani-cli {};
  anime4k = prev.callPackage ./anime4k {};
  #shadower = prev.callPackage ./shadower {};

  # catppuccin packages
  catppuccin-gtk = prev.callPackage ../catppuccin-gtk.nix {};
  catppuccin-folders = prev.callPackage ../catppuccin-folders.nix {};
  catppuccin-cursors = prev.callPackage ../catppuccin-cursors.nix {};

  cloneit = prev.callPackage ../cloneit.nix {};
  proton-ge = prev.callPackage ../proton-ge.nix {};
}
