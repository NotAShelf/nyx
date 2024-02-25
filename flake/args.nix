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
    # extended nixpkgs library, contains my custom functions
    # such as system builders
    lib = import (inputs.self + /lib) {inherit inputs;};

    # add `pins` to self so that the flake may refer it freely
    pins = import ./npins;
  };
}
