{inputs, ...}: {
  perSystem = {
    config,
    system,
    ...
  }: {
    imports = [
      {
        _module.args = {
          pkgs = config.legacyPackages;
          pins = import ./npins;
        };
      }
    ];

    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
      overlays = [];
    };
  };

  flake = {
    # an extension of nixpkgs.lib, containing my custom functions
    # used within the flake. for convenience and to allow those functions
    # to be used in other flake expressions, it has been added to a custom
    # `lib` output from the flake.
    lib = import (inputs.self + /lib) {inherit inputs;};

    # add `pins` to self so that the flake may refer it freely
    pins = import ./npins;

    # add a collection of SSH keys to the keys so that
    #  1. my public keys are more easily obtainable from outside
    #  2. it's easy to share key names and values internally, for users and such
    keys = import ./keys;
  };
}
