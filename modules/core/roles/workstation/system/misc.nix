{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes) {
    # enable polkit for privilege escalation
    security.polkit.enable = true;

    # Firefox cache on tmpfs
    fileSystems."/home/notashelf/.cache/mozilla/firefox" = {
      device = "tmpfs";
      fsType = "tmpfs";
      noCheck = true;
      options = [
        "noatime"
        "nodev"
        "nosuid"
        "size=128M"
      ];
    };

    # enable the unified cgroup hierarchy (cgroupsv2)
    systemd.enableUnifiedCgroupHierarchy = true;
  };
}
