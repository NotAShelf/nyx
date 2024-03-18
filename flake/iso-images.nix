{self, ...}: {
  # ISO images based on available hosts. We avoid basing ISO images
  # on active (i.e. desktop) hosts as they likely have secrets set up.
  # Images below are designed specifically to be used as live media
  # and can be built with `nix build .#images.<hostname>`
  # alternatively hosts can be built with `nix build .#nixosConfigurations.hostName.config.system.build.isoImage`
  flake.images = {
    # Installation iso
    gaea = self.nixosConfigurations.gaea.config.system.build.isoImage;

    # air-gapped VM
    erebus = self.nixosConfigurations.erebus.config.system.build.isoImage;
  };
}
