# credits go to @eclairevoyant on this one
# lets us import modules from PRs that are not yet merged
# and handles disabling of the relevant module locally
# I've extracted the modules section to make this system more robust and explicit
{
  lib,
  modulesPath,
  ...
}: let
  inherit (builtins) fetchTree getAttr map;
  inherit (lib.attrsets) attrValues;

  modules = import ./modules.nix;

  transcendModules =
    map ({
      # repo details
      owner,
      repo,
      rev,
      narHash,
      # module path
      module,
    }: {
      disabledModules = modulesPath + module;
      importedModules =
        (fetchTree {
          type = "github";
          inherit owner repo rev narHash;
        })
        + "/nixos/modules/${module}";
    })
    (attrValues modules);
in {
  disabledModules = map (getAttr "disabledModules") transcendModules;
  imports = map (getAttr "importedModules") transcendModules;
}
