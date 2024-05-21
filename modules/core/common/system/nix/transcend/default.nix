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

  modules = {
    # the name here is arbitrary, and is used as an identifier
    # what matters is the presence of owner, module and rev
    "nix-gc" = {
      # https://github.com/NixOS/nixpkgs/pull/260620
      owner = "nobbz";
      repo = "nixpkgs";
      rev = "10ec045f1dc82c72630c85906e1ae1d54340a7e0";
      narHash = "sha256-AV3TXXWp0AxM98wCbEa3iThUQ5AbTMC/3fZAa50lfKI=";
      module = "/services/misc/nix-gc.nix";
    };
  };

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
