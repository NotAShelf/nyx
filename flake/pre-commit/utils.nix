{pkgs, ...}: let
  toTOML = name: (pkgs.formats.toml {}).generate "${name}";

  excludes = ["flake.lock" "r'.+\.age$'" "r'.+\.sh$'"];
  mkHook = name: prev:
    {
      inherit excludes;
      description = "pre-commit hook for ${name}";
      fail_fast = true; # running hooks if this hook fails
      verbose = true;
    }
    // prev;
in {
  inherit toTOML excludes mkHook;
}
