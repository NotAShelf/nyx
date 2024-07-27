{
  self,
  lib,
  ...
}: let
  inherit (builtins) mapAttrs;
  inherit (lib.trivial) const;
  inherit (lib.attrsets) mapAttrs' foldlAttrs filterAttrs recursiveUpdate nameValuePair;

  toHydraJob =
    foldlAttrs
    (jobset: system: attrs:
      recursiveUpdate jobset
      (mapAttrs (const (drv: {${system} = drv;}))
        (filterAttrs (name: const (name != "default")) attrs)))
    {};

  # This is a simple-ish way to generate a flake that has a jobset for each
  # nixosConfiguration available in the schema. Very costy though.
  configJobs = mapAttrs' (name: config: nameValuePair "nixos-${name}" config.config.system.build.toplevel) self.nixosConfigurations;
in {
  flake.hydraJobs = {
    packages = toHydraJob self.packages;
    checks = toHydraJob self.checks;

    # FIXME: opensnitch uses an IFD, which is disallowed in hydraJobs.
    # inherit configJobs;
  };
}
