{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib.lists) foldl;
  inherit (lib.attrsets) recursiveUpdate attrValues;
  inherit (import ./common.nix {inherit lib;}) import';

  # DAG library is a modified version of the one found in
  # rycee's NUR repository
  dag = import' ./network/dag.nix;
  libModules = {
    inherit dag;

    # Various helpful utility functions that are used multiple times
    # around the configuration, thus being absorbed into this library.
    builders = import' ./builders.nix {inherit inputs;}; # System builders, abstractions over nixosSystem
    services = import' ./services.nix; # Functions for working with systemd services.
    validators = import' ./validators.nix; # Various assertions for verifying system features.
    helpers = import' ./helpers; # Helpful functions that are needed by other utilities.
    hardware = import' ./hardware.nix; # Hardware capability checks, similar to validators.
    xdg = import' ./xdg; # XDG user directories and templates.

    # Functions around building
    firewall = import' ./network/firewall.nix {inherit dag;}; # Chain and table helpers for nftables
    namespacing = import' ./network/namespacing.nix; # TODO

    # aliases for commonly used strings or functions
    aliases = import' ./aliases.nix;
  };

  importedLibs = attrValues libModules;
  extendedLib = lib.extend (_: _: foldl recursiveUpdate {} importedLibs);
in {
  perSystem = {
    # set the `lib` arg of the flake as the extended lib. If I am right, this should
    # override the previous argument (i.e. the original nixpkgs.lib) with my own
    # which is the nixpkgs library, but with my own custom actions.
    imports = [{_module.args.lib = extendedLib;}];
  };

  flake = {
    # also set `lib` as a flake output, which allows for it to be referenced outside
    # the scope of this flake. This is useful for when I want to refer to my extended
    # library from outside this flake, or if someone wants to access my functions
    # but that rarely happens, Ctrl+C and Ctrl+V is the developer way it seems.
    lib = extendedLib;
  };
}
