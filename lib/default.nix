{
  nixpkgs,
  lib,
  ...
}:
with lib;
  nixpkgs.lib.extend (
    final: prev: {
      # filter files that have the .nix suffix
      filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

      # import files that are selected by filterNixFiles
      importNixFiles = path:
        (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
            (filterAttrs filterNixFiles (builtins.readDir path))))
        import;

      # a function that checks for the existence of a group
      # TODO: this function needs config to be inherited in flake.nix, but config is not a thing in the flake
      # maybe import this lib elsewhere?
      # ifTheyExist = config: groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    }
  )
