{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
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
        # FIXME: upstream tcpcrypt service has this weird bug that causes it to fail to restart on a rebuild switch
        # likely because I lose all connectivity somewhere inbetween the switch start and end
        restart = "on-failure"; # "never" ???
        RestartSec = 10; # wait longer between restarts

        RuntimeDirectory = "tcpcryptd"; # refers to /run/tcpccypt
        RuntimeDirectoryMode = "0700"; # give the user full access in the runtime directory
      };

      preStart = ''
        ${pkgs.procps}/bin/sysctl -n net.ipv4.tcp_ecn > /run/tcpcryptd/pre-tcpcrypt-ecn-state
        ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=0
      '';

      script = "${pkgs.tcpcrypt}/bin/tcpcryptd -x 0x10 -vvvv";

      postStop = ''
        if [ -f /run/tcpcryptd/pre-tcpcrypt-ecn-state ]; then
          ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=$(cat /run/tcpcryptd/pre-tcpcrypt-ecn-state)
        fi
      '';
    };
  };
}
