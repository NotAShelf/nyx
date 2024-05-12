{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.strings) concatStringsSep;
in {
  # https://dataswamp.org/~solene/2022-09-28-earlyoom.html
  # avoid the linux kernel locking itself when we're putting too much strain on the memory
  # this helps avoid having to shut down forcefully when we OOM
  services.earlyoom = {
    enable = true;
    enableNotifications = true; # annoying, but we want to know what's killed
    reportInterval = 0;
    freeSwapThreshold = 2;
    freeMemThreshold = 4;
    extraArgs = let
      # applications that we would like to avoid killing
      # when system is under high memory pressure
      appsToAvoid = concatStringsSep "|" [
        "Hyprland" # avoid killing the graphical session
        "foot" # terminal, might have unsaved files
        "cryptsetup" # avoid killing the disk encryption manager
        "dbus-daemon" # avoid killing the dbus daemon
        "dbus-broker" # on newer, nixos versions broker is the default
        "Xwayland" # avoid killing the X11 server
        "gpg-agent" # avoid killing the gpg agent
      ];

      # apps that we would like killed first
      # those are likely the ones draining most memory
      appsToPrefer = concatStringsSep "|" [
        # browsers
        "Web Content"
        "Isolated Web Co"
        "chromium"
        # electron applications
        "electron" # I wish we could kill electron permanently
        ".*.exe"
        "java"
        # added 2024-05-12: PipeWire locked down my system as it failed to acquire RT privileges
        "pipewire(.*)" # catch pipewire and pipewire-pulse
      ];
    in [
      "-g" # kill all processes within a process group
      "--avoid '^(${appsToAvoid})$'" # things we want to not kill
      "--prefer '^(${appsToPrefer})$'" # things we want to kill as soon as possible
    ];

    # we should ideally write the logs into a designated log file; or even better, to the journal
    # for now we can hope this echo sends the log to somewhere we can observe later
    killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
      echo "Process $EARLYOOM_NAME ($EARLYOOM_PID) was killed"
    '';
  };

  # Harden the earlyoom service based on some upstream defaults
  # and some other options that I prefer having set. Normally
  # I look at a stable distro, such as Fedora, before setting
  # serviceConfig options but as far as I can tell, Fedora
  systemd.services.earlyoom.serviceConfig = {
    # from upstream
    DynamicUser = true;
    AmbientCapabilities = "CAP_KILL CAP_IPC_LOCK";
    Nice = -20;
    OOMScoreAdjust = -100;
    ProtectSystem = "strict";
    ProtectHome = true;
    Restart = "always";
    TasksMax = 10;
    MemoryMax = "50M";

    # rotection rules. Mostly from the `systemd-oomd` service
    # with some of them already included upstream.
    CapabilityBoundingSet = "CAP_KILL CAP_IPC_LOCK";
    PrivateDevices = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;

    PrivateNetwork = true;
    IPAddressDeny = "any";
    RestrictAddressFamilies = "AF_UNIX";

    SystemCallArchitectures = "native";
    SystemCallFilter = ["@system-service" "~@resources @privileged"];
  };
}
