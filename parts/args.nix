{inputs, ...}: let
  # Add `pins` to self so that the flake may refer it freely by accessing
  # `pins` in an argset (e.g. `{pkgs, lib, pins, ...}`).
  # Pinned sources can be updated via `npins update` in `flake/`
  # which will automatically bump all sources in the `npins`
  # directory relatvie to this file.
  pinnedSources = import ./npins;

  # Add a collection of SSH keys to the keys so that
  #  1. My public keys are more easily obtainable from outside
  #  2. It's easy to share key names and values internally especially
  #  for setting them for users, services, etc.
  publicKeys = import ./keys.nix;
in {
  perSystem = {
    config,
    system,
    ...
  }: {
    # Configure nixpkgs locally and expose it as <flakeRef>.legacyPackages.
    # This will then be consumed to override flake-parts' pkgs argument
    # to make sure pkgs instances in flake-parts modules are all referring
    # to the same configuration instance - this one.
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      overlays = [inputs.self.overlays.default];
    };

    _module.args = {
      # Pass `pins` and `keys` to flake-parts' module args. This allows
      # parts of the module system to refer to them in a more concise
      # way than importing them directly.
      pins = pinnedSources;
      keys = publicKeys;

      # Unify all instances of nixpkgs into a single `pkgs` set
      # Wthat includes our own overlays within `perSystem`. This
      # is not done by flake-parts, so we do it ourselves.
      # See:
      #  <https://github.com/hercules-ci/flake-parts/issues/106#issuecomment-1399041045>
      pkgs = config.legacyPackages;
    };
  };

  flake = {
    pins = pinnedSources;
    keys = publicKeys;
  };
}
