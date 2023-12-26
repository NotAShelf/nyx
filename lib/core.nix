{lib}: let
  inherit (lib) recursiveUpdate;

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

  # recursively merges two attribute sets
  # it is used to convert the importedLibs list into an attrset
  # there is probably a better way to do it, more cleanly - but I wouldn't know
  mergeRecursively = lhs: rhs: recursiveUpdate lhs rhs;
in {
  inherit import' mergeRecursively;
}
