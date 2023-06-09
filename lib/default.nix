{
  nixpkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) lists mapAttrsToList filterAttrs hasSuffix;

  builders = import ./builders.nix {inherit lib inputs nixpkgs;};
  services = import ./services.nix {inherit lib;};
  validators = import ./validators.nix {inherit lib;};

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
in
  nixpkgs.lib.extend (
    self: super:
      {inherit filterNixFiles importNixFiles boolToNum fetchKeys;} // builders // services // validators
  )
