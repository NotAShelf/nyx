{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl recursiveUpdate;

  # the below function is by far the most cursed I've put in my configuration
  # if you are, for whatever reason, copying my configuration - PLEASE omit this
  # and do your imports manually
  # credits go to @nrabulinski
  import' = path: let
    func = import path;
    args = lib.functionArgs func;
    requiredArgs = lib.filterAttrs (_: val: !val) args;
    defaultArgs = (lib.mapAttrs (_: _: null) requiredArgs) // {inherit lib;};
    functor = {__functor = _: attrs: func (defaultArgs // attrs);};
  in
    (func defaultArgs) // functor;

  # helpful utility functions used around the system
  builders = import' ./builders.nix {inherit inputs;}; # system builders
  services = import' ./services.nix; # systemd-service generators
  validators = import' ./validators.nix; # validate system conditions
  helpers = import' ./helpers.nix; # helper functions
  hardware = import' ./hardware.nix; # hardware capability checks

  # abstractions over networking functions
  # dag library is a modified version of the one found in
  # rycee's NUR repository
  dag = import' ./network/dag.nix; # dag is in network because it's designed for network only use
  firewall = import' ./network/firewall.nix {inherit dag;}; # build nftables tables and chains
  namespacing = import' ./network/namespacing.nix; # TODO

  # aliases for commonly used strings or functions
  aliases = import' ./aliases.nix;

  # recursively merges two attribute sets
  # it is used to convert the importedLibs list into an attrset
  # there is probably a better way to do it, more cleanly - but I wouldn't know
  mergeRecursively = lhs: rhs: recursiveUpdate lhs rhs;
  importedLibs = [builders services validators helpers hardware aliases firewall namespacing dag];
in
  # extend nixpkgs lib
  lib.extend (_: _: foldl mergeRecursively {} importedLibs)
