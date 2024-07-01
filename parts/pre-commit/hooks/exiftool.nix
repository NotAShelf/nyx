{
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (import ../utils.nix {inherit pkgs lib;}) mkHook;
    inherit (lib.strings) concatStringsSep;

    exiftoolArgs = [
      "-all="
      "-ext '!svg'"
      "--icc_profile:all"
      "-tagsfromfile"
      "@"
      "-orientation"
      "-overwrite_original"
    ];
  in {
    pre-commit.settings = {
      hooks.exiftool = mkHook "exiftool" {
        enable = true;
        types = ["image"];
        entry = "${pkgs.exiftool}/bin/exiftool ${concatStringsSep " " exiftoolArgs}";
      };
    };
  };
}
