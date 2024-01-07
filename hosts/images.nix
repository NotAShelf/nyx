{inputs, ...}: let
  inherit (inputs) self;
in {
  # Installation iso
  gaea = self.nixosConfigurations.gaea.config.system.build.isoImage;

  # air-gapped VM
  erebus = self.nixosConfigurations.erebus.config.system.build.isoImage;
}
