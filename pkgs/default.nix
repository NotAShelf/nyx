{pkgs, ...}: {
  # Custom rofi plugins
  rofi-calc-wayland = pkgs.callPackage ./rofi-calc-wayland.nix {};
  rofi-emoji-wayland = pkgs.callPackage ./rofi-emoji-wayland.nix {};

  # My personal derivations for packages that are not on nixpkgs
  fastfetch = pkgs.callPackage ./overlays/fastfetch {};
  shadower = pkgs.callPackage ./overlays/shadower {};

  nicksfetch = pkgs.callPackage ./nicksfetch.nix {};
  cloneit = pkgs.callPackage ./cloneit.nix {};
  discordo = pkgs.callPackage ./discordo.nix {};
  proton-ge = pkgs.callPackage ./proton-ge.nix {};
  wl-clip-persist = pkgs.callPackage ./wl-clip-persist.nix {};
}
