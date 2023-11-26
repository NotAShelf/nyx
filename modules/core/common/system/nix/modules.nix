# credits go to @eclairevoyant on this one
# lets us import modules from PRs that are not yet merged
# and handles disabling of the relevant module locally
# I've extracted the modules section to make this system more robust
{
  lib,
  modulesPath,
  ...
}: let
  inherit (builtins) fetchTree getAttr map;
  inherit (lib.attrsets) attrValues;

  modules = {
    # the name here is arbitrary, and is used as an identifier
    # what matters is the presence of owner, rev and module
    nix-gc = {
      # https://github.com/NixOS/nixpkgs/pull/260620
      owner = "nobbz";
      rev = "10ec045f1dc82c72630c85906e1ae1d54340a7e0";
      module = "/services/misc/nix-gc.nix";
    };
  };

  transcendModules =
    map ({
      owner,
      repo ? "nixpkgs",
      rev,
      module,
    }: {
      disabledModules = modulesPath + module;
      importedModules =
        (fetchTree {
          inherit owner repo rev;
          type = "github";
        })
        + "/nixos/modules/${module}";
    })
    (attrValues modules);
in {
  disabledModules = map (getAttr "disabledModules") transcendModules;
  imports = map (getAttr "importedModules") transcendModules;
}
