{inputs, ...}: let
  inherit (inputs) self;
in {
  # Installation iso
  gaea = self.nixosConfigurations.gaea.config.system.build.isoImage;

  # SD Card Image
  uranus = self.nixosConfigurations.uranus.config.system.build.sdImage;

  # air-gapped VM
  erebus = self.nixosConfigurations.erebus.config.system.build.isoImage;
}
