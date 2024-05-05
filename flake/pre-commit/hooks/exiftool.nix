{
  perSystem = {pkgs, ...}: let
    inherit (import ../utils.nix {inherit pkgs;}) mkHook;
  in {
    pre-commit.settings = {
      hooks.exiftool = mkHook "exiftool" {
        enable = true;
        types = ["image"];
        entry = ''
          ${pkgs.exiftool}/bin/exiftool \
            -all= --icc_profile:all -tagsfromfile @ -orientation -overwrite_original
        '';
      };
    };
  };
}
