_: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {pkgs, ...}: {
    packages = {
      plymouth-themes = pkgs.callPackage ./plymouth-themes.nix {};
      fastfetch = pkgs.callPackage ./fastfetch.nix {};
      ani-cli = pkgs.callPackage ./ani-cli.nix {};
      mov-cli = pkgs.callPackage ./mov-cli.nix {};
      anime4k = pkgs.callPackage ./anime4k.nix {};
      spotify-wrapped = pkgs.callPackage ./spotify-wrapped.nix {};
      cloneit = pkgs.callPackage ./cloneit.nix {};
      discordo = pkgs.callPackage ./discordo.nix {};
      nicksfetch = pkgs.callPackage ./nicksfetch.nix {};
      rofi-calc-wayland = pkgs.callPackage ./rofi-calc-wayland.nix {};
      rofi-emoji-wayland = pkgs.callPackage ./rofi-emoji-wayland.nix {};
      rat = pkgs.callPackage ./rat.nix {};
      foot-transparent = pkgs.callPackage ./foot-transparent.nix {};
      present = pkgs.callPackage ./present.nix {};
      reposilite = pkgs.callPackage ./reposilite.nix {};
    };
  };
}
