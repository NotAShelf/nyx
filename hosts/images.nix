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
  # TODO: build on non-nixos for better reproducibility
  prometheus =
    (self.nixosConfigurations.prometheus.extendModules {
      modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"];
      # modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"]; ????
    })
    .config
    .system
    .build
    .isoImage;
  icarus =
    (self.nixosConfigurations.icarus.extendModules {
      modules = ["${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"];
    })
    .config
    .system
    .build
    .isoImage;
  gaea =
    (self.nixosConfigurations.gaea)
    .config
    .system
    .build
    .isoImage;
}
