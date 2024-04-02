{
  systems = ["x86_64-linux"];
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage runCommandLocal;

    gen-notes = callPackage ./tools/gen.nix {};
    gen-rss = callPackage ./tools/rss.nix {};
  in {
    packages = {
      inherit gen-notes gen-rss;

      static-notes = runCommandLocal "static-notes" {} ''
        mkdir -p $out

        ${gen-notes}/bin/generate-static-notes
        ${gen-rss}/bin/generate-rss
      '';
    };
  };
}
