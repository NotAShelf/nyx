{lib, ...}: let
  inherit (lib.options) mkOptionDefault;
  inherit (lib.attrsets) mapAttrs recursiveUpdate;

  # make a service that is a part of the graphical session target
  mkGraphicalService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };

  # make a service that is a part of the hyprland session target
  mkHyprlandService = recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["hyprland-session.target"];
  };

  hardenService = attrs:
    attrs
    // (mapAttrs (_: mkOptionDefault) {
      AmbientCapabilities = "";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateMounts = true;
      PrivateTmp = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        # Route-chain and OpenJ9 requires @resources calls
        "~@clock @cpu-emulation @debug @module @mount @obsolete @privileged @raw-io @reboot @swap"
      ];
    });
in {
  inherit hardenService mkGraphicalService mkHyprlandService;
}
