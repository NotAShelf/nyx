{
  systems = ["x86_64-linux"];
  perSystem = {pkgs, ...}: let
    inherit (pkgs) runCommandLocal;
  in {
    packages = {
      static-notes = runCommandLocal "static-notes" {} ''
        mkdir -p $out
      '';
    };
  };
}
