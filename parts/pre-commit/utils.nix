{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) recursiveUpdate;

  # Files to be ignored by all hooks.
  excludes = ["LICENSE" "flake.lock" "\.svg$" "\.age$" "\.sh$"];

  # Helper function to generate TOML configuration for pre-commit hooks
  # that read TOML configurations.
  toTOML = name: (pkgs.formats.toml {}).generate "${name}";

  # Recursively updates a hook configuration set with the preset
  # configuration options.
  presetConfigFor = name: {
    inherit excludes;
    description = "pre-commit hook for ${name}";
    fail_fast = true; # running hooks if this hook fails
    verbose = true;
  };

  # Note: hookConfig should be *after* presetConfig to allow overriding
  # preset defaults. If this list is flipped, values present in presetConfig
  # will override hookConfig.
  mkHook = name: hookConfig: recursiveUpdate (presetConfigFor name) hookConfig;
in {
  inherit toTOML excludes mkHook;
}
