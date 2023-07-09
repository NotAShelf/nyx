{
  nixpkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  self = inputs.self;
in
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

      # return an int (1/0) based on boolean value
      boolToNum = bool:
        if bool
        then 1
        else 0;

      # a basic function to fetch a specified user's public keys from github .keys url
      fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");

      # make a service that is a part of the graphical session target
      mkGraphicalService = lib.recursiveUpdate {
        Unit.PartOf = ["graphical-session.target"];
        Unit.After = ["graphical-session.target"];
        Install.WantedBy = ["graphical-session.target"];
      };

      # just an alias to nixpkgs.lib.nixosSystem, lets me avoid adding
      # nixpkgs to the scope in the file it is used in
      mkSystem = nixpkgs.lib.nixosSystem;

      # mkNixosSystem wraps mkSystem (a.k.a lib.nixosSystem) with flake-parts' withSystem to provide inputs' and self' from flake-parts
      # it also acts as a template for my nixos hosts with system type and modules being imported beforehand
      # specialArgs is also defined here to avoid defining them for each host and lazily merged if the host defines any other args
      mkNixosSystem = {
        modules,
        system,
        withSystem,
        ...
      } @ args:
        withSystem system ({
          inputs',
          self',
          ...
        }:
          mkSystem {
            inherit modules system;
            specialArgs = {inherit lib inputs self inputs' self';} // args.specialArgs or {};
          });

      # mkIso is should be a set that extends mkSystem with necessary modules
      # to create an Iso image
      # we do not use mkNixosSystem because it overcomplicates things, an ISO does not require what we get in return for those complications
      mkNixosIso = {
        modules,
        system,
        ...
      } @ args:
        mkSystem {
          inherit system;
          specialArgs = {inherit inputs lib self;} // args.specialArgs or {};
          modules =
            [
              # get an installer profile from nixpkgs to base the Isos off of
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ]
            ++ args.modules or [];
        };
    }
  )
