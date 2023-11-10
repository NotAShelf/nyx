{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl recursiveUpdate;

  # jesus christ this is insanely cursed
  # wrap the import with a pre-inherited lib to avoid typing it over and over again
  # the cost? your sanity.
  # credits to @nrabulinski for this, I cannot be held accountible for his crimes against humanity
  import' = path: let
    func = import path;
    args = lib.functionArgs func;
    requiredArgs = lib.filterAttrs (_: val: !val) args;
    defaultArgs = (lib.mapAttrs (_: _: null) requiredArgs) // {inherit lib;};
    functor = {__functor = _: attrs: func (defaultArgs // attrs);};
  in
    (func defaultArgs) // functor;

  # a modified version of NUR's dag type
  dag = import' ./dag.nix;

  # helpful utility functions used around the system
  builders = import' ./builders.nix {inherit inputs;};
  services = import' ./services.nix;
  validators = import' ./validators.nix;
  helpers = import' ./helpers.nix;
  hardware = import' ./hardware.nix;

  # abstractions over networking functions
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
