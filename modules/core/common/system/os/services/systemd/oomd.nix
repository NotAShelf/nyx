{
  config,
  lib,
  ...
}: {
  systemd = {
    # Systemd OOMd
    # Fedora enables these options by default. See the 10-oomd-* files here:
    # https://src.fedoraproject.org/rpms/systemd/tree/3211e4adfcca38dfe24188e28a65b1cf385ecfd6
    # by default it only kills cgroups. So either systemd services marked for killing under OOM
    # or (disabled by default, enabled by us) the entire user slice. Fedora used to kill root
    # and system slices, but their oomd configuration has since changed.
    # TODO: maybe disable user slice by default?
    oomd = {
      enable = !config.systemd.enableUnifiedCgroupHierarchy;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
      extraConfig = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };

    # make it that nix builds are more likely killed than important services.
    # 100 is the default for user slices and 500 is systemd-coredumpd@
    # this is important because as my system got huge, nix flake check started
    # causing OOMs and killing my desktop environment - which I do not like
    # nuke nix-daemon if it gets too memory hungry
    services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
  };
}
