{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  disabledModules = ["services/networking/tcpcrypt.nix"];
  config = mkIf (dev.type != "server") {
    # FIXME: the upstream tcpcrypd service is unmaintained and poorly designed
    # networking.tcpcrypt.enable = true;

    # create a system user for the tcpcrypt service
    # this is the user we will use the systemd service as
    users = {
      groups.tcpcryptd = {};
      users.tcpcryptd = {
        description = "tcpcrypt daemon user";
        group = "tcpcryptd";
        uid = config.ids.uids.tcpcryptd; # nixpkgs already defines a hardcoded uid, use it
      };
    };

    # enable opportunistic TCP encryption
    # this is NOT a pancea, however, if the receiver supports encryption and the attacker is passive
    # privacy will be more plausible (but not guaranteed, unlike what the option docs suggest)
    # NOTE: the systemd service below is rewritten to be an alternative to networking.tcpcrypt.enable
    # it lacks hardening and SHOULD NOT BE USED until further notice.
    systemd.services.tcpcrypt = {
      description = "tcpcrypt, opportunistic tcp encryption";

      wantedBy = ["multi-user.target"];
      after = ["network.target"];

      serviceConfig = {
        restart = "on-failure";
        RestartSec = 10;

        RuntimeDirectory = "tcpcryptd"; # refers to /run/tcpccypt
        RuntimeDirectoryMode = "0700"; # give the user full access in the runtime directory

        # hardening options
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;

        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProcSubset = "all"; # "pid" but we need /proc/sys/net/ipv4

        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "strict";

        RemoveIPC = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        ReadWritePaths = ["/proc/sys/net/ipv4"];

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          # Route-chain and OpenJ9 requires @resources calls
          "~@clock @cpu-emulation @debug @module @mount @obsolete @privileged @raw-io @reboot @swap"
        ];

        /**/
      };

      preStart = ''
        echo -en "Starting tcpcryptd\n"
        ${pkgs.procps}/bin/sysctl -n net.ipv4.tcp_ecn > /run/tcpcryptd/pre-tcpcrypt-ecn-state
        ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=0
      '';

      script = "${pkgs.tcpcrypt}/bin/tcpcryptd -x 0x10 -vvvv";

      postStop = ''
        echo -en "Stopped tcpcrypd, restoring tcp_enc state\n"
        if [ -f /run/tcpcryptd/pre-tcpcrypt-ecn-state ]; then
          ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=$(cat /run/tcpcryptd/pre-tcpcrypt-ecn-state)
        fi
      '';
    };
  };
}
