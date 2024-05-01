{
  inputs,
  self,
  ...
}: let
  # an extension of nixpkgs.lib, containing my custom functions
  # used within the flake. for convenience and to allow those functions
  # to be used in other flake expressions, it has been added to a custom
  # `lib` output from the flake.
  extendedLib = import (self + /lib) {
    inherit inputs;
  };

  # add `pins` to self so that the flake may refer it freely
  # pins can be updated via `npins update` in current directory
  # which will automatically bump all sources in the `npins`
  # directory.
  pinnedSources = import ./npins;

  # add a collection of SSH keys to the keys so that
  #  1. my public keys are more easily obtainable from outside
  #  2. it's easy to share key names and values internally especially
  #  for setting them for users and such
  publicKeys = import ./keys.nix;
in {
  perSystem = {
    config,
    system,
    ...
  }: {
    imports = [
      {
        _module.args = {
          pkgs = config.legacyPackages;
          lib = extendedLib;
          pins = pinnedSources;
          keys = publicKeys;
        };
      }
    ];

    legacyPackages = import inputs.nixpkgs {
      inherit system;
      overlays = [];
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
  };

  flake = {
    lib = extendedLib;
    pins = pinnedSources;
    keys = publicKeys;
  };
}
