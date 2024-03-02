{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  # get rid of the tcpcrypt module provided by nixpkgs
  # it is unmaintained and I cannot be arsed to PR a fix
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
    systemd.services.tcpcrypt = let
      # borrowed from fedora's tcpcrypt rpm spec
      # <https://src.fedoraproject.org/rpms/tcpcrypt/blob/rawhide/f/tcpcryptd-firewall>
      tcpcryptd-firewall = pkgs.writeShellApplication {
        name = "tcpcryptd-firewall";
        runtimeInputs = [pkgs.iptables];
        text = ''

          # use iptables manually
          if [ "$1" = "start" ]; then
              iptables -t raw -N nixos-tcpcrypt
              iptables -t raw -A nixos-tcpcrypt -p tcp -m mark --mark 0x0/0x10 -j NFQUEUE --queue-num 666
              iptables -t raw -I PREROUTING -j nixos-tcpcrypt

              iptables -t mangle -N nixos-tcpcrypt
              iptables -t mangle -A nixos-tcpcrypt -p tcp -m mark --mark 0x0/0x10 -j NFQUEUE --queue-num 666
              iptables -t mangle -I POSTROUTING -j nixos-tcpcrypt
          fi

          if [ "$1" = "stop" ]; then
              iptables -t mangle -D POSTROUTING -j nixos-tcpcrypt || true
              iptables -t raw -D PREROUTING -j nixos-tcpcrypt || true

              iptables -t raw -F nixos-tcpcrypt || true
              iptables -t raw -X nixos-tcpcrypt || true

              iptables -t mangle -F nixos-tcpcrypt || true
              iptables -t mangle -X nixos-tcpcrypt || true
          fi
        '';
      };
    in {
      description = "tcpcrypt, opportunistic tcp encryption";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "syslog.target"];

      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 10;

        RuntimeDirectory = "tcpcryptd";
        RuntimeDirectoryMode = "0750";
      };

      preStart = ''
        echo -en "Starting tcpcryptd\n"
        ${pkgs.procps}/bin/sysctl -n net.ipv4.tcp_ecn > /run/tcpcryptd/pre-tcpcrypt-ecn-state
        ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=0

        # start the firewall
        ${tcpcryptd-firewall}/bin/tcpcryptd-firewall start
      '';

      # -f disables network test
      script = "${pkgs.tcpcrypt}/bin/tcpcryptd -v -f -x 0x10 ";

      postStop = ''
        echo -en "Stopped tcpcrypd, restoring tcp_enc state\n"
        if [ -f /run/tcpcryptd/pre-tcpcrypt-ecn-state ]; then
          ${pkgs.procps}/bin/sysctl -w net.ipv4.tcp_ecn=$(cat /run/tcpcryptd/pre-tcpcrypt-ecn-state)
        fi

        # stop the firewall
        ${tcpcryptd-firewall}/bin/tcpcryptd-firewall stop
      '';
    };
  };
}
