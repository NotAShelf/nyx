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

    # Functions designed around working with the network stack. Firewall contains utilities
    # to be used with `nftables` (e.g. table and chain builders) where namespacing is a
    # work-in-progress library to work with systemd's socket namespaces.
    firewall = import' ./network/firewall.nix {inherit dag;}; # Chain and table helpers for nftables
    namespacing = import' ./network/namespacing.nix; # TODO

    # Aliases, or rather, templates containing commonly used strings or sets
    # across multiple parts of the configuration. One example for this is the nginx
    # SSL template, which is used practically for every service that faces
    # the internet.
    aliases = import' ./aliases.nix;
  };

  importedLibs = attrValues libModules;
  extendedLib = lib.extend (_: _: foldl recursiveUpdate {} importedLibs);
in {
  perSystem = {
    # Set the `lib` arg of the flake as the extended lib. If I am right, this should
    # override the previous argument (i.e. the original nixpkgs.lib, provided by flake-parts
    # as a reasonable default) with my own, which is the same nixpkgs library, but actually extended
    # with my own custom functions.
    imports = [{_module.args.lib = extendedLib;}];
  };

  flake = {
    # Also set `lib` as a flake output, which allows for it to be referenced outside
    # the scope of this flake. This is useful for when I want to refer to my extended
    # library from outside this flake, or if someone wants to access my functions
    # but that rarely happens, Ctrl+C and Ctrl+V is the developer way it seems.
    lib = extendedLib;
  };
}
