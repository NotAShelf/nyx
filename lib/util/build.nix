{
  self,
  platforms,
  lib,
  ...
}: let
  inherit (lib) flatten hasPrefix mapAttrsToList nameValuePair recursiveUpdate splitString util;
  inherit (builtins) any attrValues concatStringsSep filter hasAttr isPath listToAttrs map readFile;
in rec {
  ## Builder Functions ##
  each = attr: func:
    listToAttrs (map (name: nameValuePair name (func name)) attr);

  # Configuration Builders
  device = self.nixosModules.default.config;
  iso = config:
    device (config
      // {
        format = "iso";
        description = "Install Media";
        kernelModules = ["nvme"];
        gui.desktop = config.gui.desktop + "-minimal";

        # Default User
        user = {
          name = "nixos";
          description = "Default User";
          minimal = true;
          recovery = false;
          shells = null;
          password = readFile ../modules/user/passwords/default;
        };
      });

  # Package Channels Builder
  channel = src: overlays: patch: let
    patches = util.map.patches patch;
  in
    each platforms (system: let
      pkgs = src.legacyPackages."${system}";
    in
      (
        if !(any isPath patches)
        then import src
        else
          import (pkgs.applyPatches {
            inherit src patches;
            name = "Patched-Input_${src.shortRev}";
          })
      ) {
        inherit system;
        config = import ../modules/nix/config.nix;
        overlays =
          overlays
          ++ (attrValues self.overlays or {})
          ++ [
            (final: prev:
              recursiveUpdate {custom = self.packages."${system}";}
              self.channels."${system}")
          ];
      });

  # Mime Types Handler
  mime = values: option:
    listToAttrs (flatten (mapAttrsToList (name: types:
      if hasAttr name option
      then map (type: nameValuePair type option."${name}") types
      else [])
    values));

  # Script Builder
  script = file:
    concatStringsSep "\n"
    ((filter (line: line != "" && !(hasPrefix "#!" line)))
      (splitString "\n" (readFile file)));
}
