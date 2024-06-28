{
  inputs,
  self,
  ...
}: let
  installerModule = "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix";
in {
  # ISO images based on available hosts. We avoid basing ISO images
  # on active (i.e. desktop) hosts as they likely have secrets set up.
  # Images below are designed specifically to be used as live media
  # and can be built with `nix build .#images.<hostname>`
  # alternatively hosts can be built with `nix build .#nixosConfigurations.hostName.config.system.build.isoImage`
  flake.images = let
    gaea = self.nixosConfigurations."gaea";
    erebus = self.nixosConfigurations."erebus";
    atlas = self.nixosConfigurations."atlas".extendModules {modules = [installerModule];};
  in {
    # Installation iso
    gaea = gaea.config.system.build.isoImage;

    # air-gapped VM
    erebus = erebus.config.system.build.isoImage;

    # Raspberry Pi 400
    atlas = atlas.config.system.build.sdImage;
  };
}
