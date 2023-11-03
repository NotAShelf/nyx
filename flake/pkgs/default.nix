_: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {pkgs, ...}: {
    packages = {
      plymouth-themes = pkgs.callPackage ./plymouth-themes.nix {};
      anime4k = pkgs.callPackage ./anime4k.nix {};
      spotify-wrapped = pkgs.callPackage ./spotify-wrapped.nix {};
      nicksfetch = pkgs.callPackage ./nicksfetch.nix {};
      present = pkgs.callPackage ./present.nix {};
    };
  };
}
