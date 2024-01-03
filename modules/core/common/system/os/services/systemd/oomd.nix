{config, ...}: {
  systemd = {
    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/3211e4adfcca38dfe24188e28a65b1cf385ecfd6
    # by default it only kills cgroups. So either systemd services marked for killing under OOM
    # or (disabled by default, enabled by us) the entire user slice. Fedora used to kill root
    # and system slices, but their oomd configuration has since changed.
    oomd = {
      enable = !config.systemd.enableUnifiedCgroupHierarchy;
      enableRootSlice = false;
      enableSystemSlice = false;
      enableUserSlices = false;
      extraConfig = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };
  };
}
