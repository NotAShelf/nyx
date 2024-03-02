{
  # discard blocks that are not in use by the filesystem, good for SSDs
  services.fstrim = {
    # we may enable this unconditionally across all systems becuase it's performance
    # impact is negligible on systems without a SSD - which means it's a no-op with
    # almost no downsides aside from the service firing once per week
    enable = true;

    # the default value, good enough for average-load systems
    interval = "weekly";
  };
}
