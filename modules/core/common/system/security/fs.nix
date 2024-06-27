{
  fileSystems = let
    defaults = ["nodev" "nosuid" "noexec"];
  in {
    # Mount some filesystems with secure defaults to disallow
    # running executables, setuid binaries, and device files.
    # We could consider /tmp here, but that breaks e.g. makefiles
    # while building packages.
    # See:
    #  <https://wiki.archlinux.org/title/Security#Mount_options>
    "/var/log".options = defaults;
    "/boot".options = defaults;
  };
}
