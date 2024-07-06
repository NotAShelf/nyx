{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) substring;
  inherit (lib.sources) cleanSource;
  inherit (lib.modules) mkDefault mkImageMediaOverride;
in {
  # the ISO image must be completely immutable in the sense that we do not
  # want the user to be able modify the ISO image after booting into it
  # the below option will disable rebuild switches (i.e nixos-rebuild switch)
  system.switch.enable = false;

  isoImage = let
    # `hostname` will always be defined as a "top-level" attribute in hosts.nix
    # while the host is being "constructed" so to speak. Therefore we can use
    # networking.hostName (instead of `meta.hostname`) to get the hostname
    # of the system we are building the ISO for without hardcoding anything
    # in this role module, since this is meant to be system-agnostic. Though
    # at the off chance that networking.hostName is not defined, we default to
    # "nixos" as the hostname to avoid errors or empty strings.
    hostname = config.networking.hostName or "nixos";

    # if the system is built from a git repository, we want to include the git revision
    # in the ISO name. If the tree is dirty, we use the term "dirty" to make it explicit
    # and include the date in the ISO name.
    rev = self.shortRev or "${substring 0 8 self.lastModifiedDate}-dirty";

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

    # Maximum compression in exchange for speed, assuming ISOs to be built on GHA CI
    # which has a 2GB limit for uploaded artifacts. Use mkDefault to allow hosts that
    # import this role to override the compression options, potentially for faster builds
    # or if the build host has space to spare.
    squashfsCompression = mkDefault "zstd -Xcompression-level 19"; # default uses gzip

    # ISO image should be an EFI-bootable volume
    makeEfiBootable = true;

    # ISO image should be bootable from USB
    # FIXME: the module description is as follows:
    # "Whether the ISO image should be bootable from CD as well as USB."
    # is this supposed to make the ISO image bootable from *CD* instead of USB?
    makeUsbBootable = true;

    # Get rid of "installer" suffix in boot menu. Not all ISO images are
    # installers.
    appendToMenuLabel = "";

    contents = [
      {
        # My module system already contains an option to add memtest86+
        # to the boot menu at will but in case our system is unbootable
        # lets include memtest86+ in the ISO image
        # so that we may test the memory of the system
        # exclusively from the ISO image
        source = pkgs.memtest86plus + "/memtest.bin";
        target = "/boot/memtest.bin";
      }
      {
        # Link system flake to /root/nyx so that the user can
        # can initiate a rebuild without having to clone and wait
        # useful if this installer is meant to be used on a system
        # that cannot access GitHub.
        source = cleanSource self;
        target = "/root/nyx";
      }
    ];
  };
}
