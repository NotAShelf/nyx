{lib, ...}: let
  inherit (lib) lists mapAttrsToList filterAttrs hasSuffix;

  # filter files that have the .nix suffix
  filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

  # import files that are selected by filterNixFiles
  importNixFiles = path:
    (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  # return an int (1/0) based on boolean value
  # `boolToNum true` -> 1
  boolToNum = bool:
    if bool
    then 1
    else 0;

  # convert a list of integers to a list of string
  # `intListToStringList [1 2 3]` -> ["1" "2" "3"]
  intListToStringList = list: map (toString list);

  # a basic function to fetch a specified user's public keys from github .keys url
  # `fetchKeys "username` -> "ssh-rsa AAAA...== username@hostname"
  fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");

  # a helper function that checks if a list contains a list of given strings
  # `containsStrings { targetStrings = ["foo" "bar"]; list = ["foo" "bar" "baz"]; }` -> true
  containsStrings = {
    list,
    targetStrings,
  }:
    builtins.all (s: builtins.any (x: x == s) list) targetStrings;

  # indexOf is a function that returns the index of an element in a list
  # `indexOf ["foo" "bar" "baz"] "bar"` -> 1
  indexOf = list: elem: let
    f = f: i:
      if i == (builtins.length list)
      then null
      else if (builtins.elemAt list i) == elem
      then i
      else f f (i + 1);
  in
    f f 0;
in {
  inherit filterNixFiles importNixFiles boolToNum fetchKeys containsStrings indexOf intListToStringList;
}
