final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  fastfetch = prev.callPackage ./fastfetch {};
  ani-cli = prev.callPackage ./ani-cli {};
  mov-cli = prev.callPackage ./mov-cli {};
  anime4k = prev.callPackage ./anime4k {};
  shadower = prev.callPackage ./shadower {};
  spotify-wrapped = prev.callPackage ./spotify-wrapped {};

  # catppuccin packages
  # catppuccin-gtk = prev.callPackage ../catppuccin-gtk.nix {};
  # catppuccin-folders = prev.callPackage ../catppuccin-folders.nix {};
  # catppuccin-cursors = prev.callPackage ../catppuccin-cursors.nix {};

  cloneit = prev.callPackage ../cloneit.nix {};
  proton-ge = prev.callPackage ../proton-ge.nix {};
}
