{
  nixpkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) lists mapAttrsToList filterAttrs hasSuffix;

  builders = import ./builders.nix {inherit lib inputs nixpkgs;};
  services = import ./services.nix {inherit lib;};

  # filter files that have the .nix suffix
  filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

  # import files that are selected by filterNixFiles
  importNixFiles = path:
    (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  # return an int (1/0) based on boolean value
  boolToNum = bool:
    if bool
    then 1
    else 0;

  # a basic function to fetch a specified user's public keys from github .keys url
  fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");

  # a function that will append a list of groups if they exist in config.users.groups
  ifTheyExist = config: groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

  # a function that returns a boolean based on whether or not the groups exist
  ifGroupsExist = config: groups: lib.any (group: builtins.hasAttr group config.users.groups) groups;
in
  nixpkgs.lib.extend (
    self: super:
      {inherit filterNixFiles importNixFiles boolToNum fetchKeys ifTheyExist ifGroupsExist;} // builders // services
  )
