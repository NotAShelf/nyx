{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) cleanSource mkImageMediaOverride;
in {
  # the ISO image must be completely immutable in the sense that we do not
  # want the user to be able modify the ISO image after booting into it
  # the below option will disable rebuild switches (i.e nixos-rebuild switch)
  system.switch.enable = false;

  isoImage = let
    # hostname will be set as a "top-level" attribute in hosts.nix, per-host.
    # therefore we can use the networking.hostName to get the hostname of the live
    # system without defining it explicitly in the system-agnostic ISO role module
    hostname = config.networking.hostName or "nixos";

    # if the system is built from a git repository, we want to include the git revision
    # in the ISO name. If the tree is dirty, we use the term "dirty" to make it explicit
    # and include the date in the ISO name.
    rev = self.shortRev or "${builtins.substring 0 8 self.lastModifiedDate}-dirty";

    # the format of the iso will always be uniform:
    # $hostname-$release-$rev-$arch
    # therefore we can set it once to avoid repetition later on
    name = "${hostname}-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";
  in {
    # this will cause the resulting .iso file to be named as follows:
    # $hostname-$release-$rev-$arch.iso
    isoName = mkImageMediaOverride "${name}.iso";
    # this will cause the label or volume ID of the generated ISO image to be as follows:
    # $hostname-$release-$rev-$arch
    # volumeID is used is used by stage 1 of the boot process, so it must be distintctive
    volumeID = mkImageMediaOverride "${name}";

    # maximum compression, in exchange for build speed
    squashfsCompression = "zstd -Xcompression-level 10"; # default uses gzip

    # ISO image should be an EFI-bootable volume
    makeEfiBootable = true;

    # ISO image should be bootable from USB
    # FIXME: the module description is as follows:
    # "Whether the ISO image should be bootable from CD as well as USB."
    # is this supposed to make the ISO image bootable from *CD* instead of USB?
    makeUsbBootable = true;

    contents = [
      {
        # my module system already contains an option to add memtest86+
        # to the boot menu at will but in case our system is unbootable
        # lets include memtest86+ in the ISO image
        # so that we may test the memory of the system
        # exclusively from the ISO image
        source = pkgs.memtest86plus + "/memtest.bin";
        target = "/boot/memtest.bin";
      }
      {
        # link this flake to /etc/nixos/flake so that the user can
        # can initiate a rebuild without having to clone and wait
        # useful if this installer is meant to be used on a system
        # that cannot access github
        source = cleanSource self;
        target = "/root/nyx";
      }
    ];
  };
}
