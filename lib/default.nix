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
    }
  )
