{
  inputs,
  self,
  ...
}: {
  # TODO: import images from a different file to de-clutter flake.nix
  atlas =
    (self.nixosConfigurations.atlas.extendModules {
      modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
    })
    .config
    .system
    .build
    .sdImage;
  gaea = self.nixosConfigurations.gaea.config.system.build.isoImage;
}
