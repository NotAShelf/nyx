{
  imports = [
    ./fs
    ./kernel
    ./modules

    ./btrfs.nix
    ./networking.nix
  ];

  config = {
    # Mount some filesystems with secure defaults to disallow
    # running executables, setuid binaries, and device files.
    # We could consider /tmp here, but that breaks e.g. makefiles
    # while building packages.
    # See:
    #  <https://wiki.archlinux.org/title/Security#Mount_options>
    fileSystems = let
      defaults = ["nodev" "nosuid" "noexec"];
    in {
      "/var/log".options = defaults;
      "/boot".options = defaults;
    };

    system.stateVersion = "23.05";
  };
}
