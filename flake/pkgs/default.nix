{inputs, ...}: {
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage;
  in {
    packages = {
      schizofox-startpage = callPackage ./startpage {};
      plymouth-themes = callPackage ./plymouth-themes.nix {};
      anime4k = callPackage ./anime4k.nix {};
      spotify-wrapped = callPackage ./spotify-wrapped.nix {};
      nicksfetch = callPackage ./nicksfetch.nix {};
      present = callPackage ./present.nix {};
      modprobed-db = callPackage ./modprobed-db.nix {};
      nixfmt-rfc = callPackage ./nixfmt-rfc.nix {inherit inputs;};
    };
  };
}
