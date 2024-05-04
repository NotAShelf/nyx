{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl recursiveUpdate;
  inherit (import ./common.nix {inherit lib;}) import';

  # helpful utility functions used around the system
  builders = import' ./builders.nix {inherit inputs;}; # system builders
  services = import' ./services.nix; # systemd-service generators
  validators = import' ./validators.nix; # validate system conditions
  helpers = import' ./helpers; # helper functions
  hardware = import' ./hardware.nix; # hardware capability checks
  xdg = import' ./xdg; # xdg user directories & templates

  # abstractions over networking functions
  # dag library is a modified version of the one found in
  # rycee's NUR repository
  dag = import' ./network/dag.nix; # dag is in network because it's designed for network only use
  firewall = import' ./network/firewall.nix {inherit dag;}; # build nftables tables and chains
  namespacing = import' ./network/namespacing.nix; # TODO

  # aliases for commonly used strings or functions
  aliases = import' ./aliases.nix;

  importedLibs = [builders services validators helpers hardware aliases firewall namespacing dag xdg];
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
