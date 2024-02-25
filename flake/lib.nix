{inputs, ...}: {
  flake = {
    # extended nixpkgs library, contains my custom functions
    # such as system builders
    lib = import (inputs.self + /lib) {inherit inputs;};
  };
}
