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

      # a function that will append a list of groups if they exist in config.users.groups
      ifTheyExist = config: groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

      # a function that returns a boolean based on whether or not the groups exist
      ifGroupsExist = config: groups: lib.any (group: builtins.hasAttr group config.users.groups) groups;

      # make a service that is a part of the graphical session target
      mkGraphicalService = lib.recursiveUpdate {
        Unit.PartOf = ["graphical-session.target"];
        Unit.After = ["graphical-session.target"];
        Install.WantedBy = ["graphical-session.target"];
      };
    }
  )
