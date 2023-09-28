{
  inputs,
  self,
  ...
}: {
  # Installer image for my Raspberry Pi
  atlas =
    (self.nixosConfigurations.atlas.extendModules {
      modules = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];
    })
    .config
    .system
    .build
    .sdImage;

  # Installation iso
  gaea = self.nixosConfigurations.gaea.config.system.build.isoImage;

  # air-gapped VM
  erebus = self.nixosConfigurations.erebus.config.system.build.isoImage;
}
