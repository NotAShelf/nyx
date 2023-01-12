final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};
  fastfetch = prev.callPackage ./fastfetch {};

  catppuccin-gtk = prev.callPackage ../../pkgs/catppuccin-gtk.nix {};
  catppuccin-folders = prev.callPackage ../../pkgs/catppuccin-folders.nix {};
  catppuccin-cursors = prev.callPackage ../../pkgs/catppuccin-cursors.nix {};

  cloneit = prev.callPackage ../../pkgs/cloneit.nix {};
  proton-ge = prev.callPackage ../../pkgs/proton-ge.nix {};
  anime4k = prev.callPackage ../../pkgs/anime4k.nix {};
}
