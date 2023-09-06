{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
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
