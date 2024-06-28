{lib, ...}: let
  inherit (builtins) fromJSON readFile;
  inherit (lib.meta) getExe;

  /*
    *
  Converts a YAML file to a JSON representation using the `yj` tool.

  # Inputs

  `pkgs`
  : A set of Nix packages, must include `yj`.

  `file`
  : A path to the YAML file to be converted.

  # Type

  ```
  fromYAML :: { pkgs: pkgs } -> file: string -> JSON
  ```
  */

  fromYAML = pkgs: file: let
    converted-json = pkgs.runCommand "yaml-converted.json" {} ''
      ${getExe pkgs.yj} < ${file} > $out
    '';
  in
    fromJSON (readFile converted-json);
in {
  inherit fromYAML;
}
