{lib, ...}: {
  imports = [
    ./catppuccin
    ./rofi
    ./cloneit.nix
    ./cloneit.nix
    ./plymouth-themes.nix
    ./proton-ge.nix
    ./rust-battop.nix
    ./wallpapers.nix
  ];

  # Catppuccin Theme Packages
    catppuccin-folders = pkgs.callPackage ./pkgs/catppuccin-folders.nix {};
    catppuccin-gtk = pkgs.callPackage ./pkgs/catppuccin-gtk.nix {};
    catppuccin-cursors = pkgs.callPackage ./pkgs/catppuccin-cursors.nix {};

    # Rofi Plugins
    rofi-calc-wayland = pkgs.callPackage ./pkgs/rofi-calc-wayland.nix {};
    rofi-emoji-wayland = pkgs.callPackage ./pkgs/rofi-emoji-wayland.nix {};

    # Misc
    cloneit = pkgs.callPackage ./pkgs/cloneit.nix {};
    battop = pkgs.callPackage ./pkgs/rust-battop.nix {};
    wallpapers = pkgs.callPackage ./pkgs/wallpapers.nix {};
}
