{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl recursiveUpdate;

  # the below function is by far the most cursed I've put in my configuration
  # if you are, for whatever reason, copying my configuration - PLEASE omit this
  # credits go to @nrabulinski for this
  import' = path: let
    func = import path;
    args = lib.functionArgs func;
    requiredArgs = lib.filterAttrs (_: val: !val) args;
    defaultArgs = (lib.mapAttrs (_: _: null) requiredArgs) // {inherit lib;};
    functor = {__functor = _: attrs: func (defaultArgs // attrs);};
  in
    (func defaultArgs) // functor;

  # helpful utility functions used around the system
  builders = import' ./builders.nix {inherit inputs;};
  services = import' ./services.nix;
  validators = import' ./validators.nix;
  helpers = import' ./helpers.nix;
  hardware = import' ./hardware.nix;

  # abstractions over networking functions
  # dag library is a modified version of the one found in
  # rycee's NUR repository
  dag = import' ./network/dag.nix;
  firewall = import' ./network/firewall.nix {inherit dag;};
  namespacing = import' ./network/namespacing.nix;

  # aliases for commonly used strings or functions
  aliases = import' ./aliases.nix;

  # recursively merges two attribute sets
  # it is used to convert the importedLibs list into an attrset
  # there is probably a better way to do it, more cleanly - but I wouldn't know
  # thus, you are subjected to my insanity. you're welcome :)
  #
  # p.s. if you're copying this (literally, why?), I want a MLA 9th ed citation for the quote above, thanks
  mergeRecursively = lhs: rhs: recursiveUpdate lhs rhs;
  importedLibs = [builders services validators helpers hardware aliases firewall namespacing dag];
in
  # extend nixpkgs lib
  lib.extend (_: _: foldl mergeRecursively {} importedLibs)
