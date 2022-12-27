final: prev: {
  nixos-plymouth = prev.callPackage ./plymouth {};

  catppuccin-gtk = prev.callPackage ../../pkgs/catppuccin-gtk.nix {};
  catppuccin-folders = prev.callPackage ../../pkgs/catppuccin-folders.nix {};
  catppuccin-cursors = prev.callPackage ../../pkgs/catppuccin-cursors.nix {};
}
