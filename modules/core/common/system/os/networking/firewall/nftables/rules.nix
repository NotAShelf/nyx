{
  config,
  lib,
  ...
}: let
  inherit (lib) entryBefore entryBetween entryAfter entryAnywhere;
in {
  networking.nftables.rules = {
    inet = {
      filter = {
        input = {
          loopback = entryAnywhere {
            field = "iifname";
            value = "lo";
            policy = "accept";
          };

          established-locally = entryAfter ["loopback"] {
            protocol = "ct";
            field = "state";
            value = ["established" "related"];
            policy = "accept";
          };

          basic-icmp6 = entryAfter ["loopback" "established-locally"] {
            protocol = "ip6 nexthdr icmpv6 icmpv6";
            field = "type";
            value = [
              "destination-unreachable"
              "packet-too-big"
              "time-exceeded"
              "parameter-problem"
              "nd-router-advert"
              "nd-neighbor-solicit"
              "nd-neighbor-advert"
              #"mld-listener-query" "nd-router-solicit" # for routers
            ];
            policy = "accept";
          };

          basic-icmp = entryAfter ["loopback" "established-locally"] {
            protocol = "ip protocol icmp icmp";
            field = "type";
            value = [
              "destination-unreachable"
              "router-advertisement"
              "time-exceeded"
              "parameter-problem"
            ];
            policy = "accept";
          };

          ping6 = entryBefore ["basic-icmp6"] {
            protocol = "ip6 nexthdr icmpv6 icmpv6";
            field = "type";
            value = "echo-request";
            policy = "accept";
          };

          ping = entryBefore ["basic-icmp"] {
            protocol = "ip protocol icmp icmp";
            field = "type";
            value = "echo-request";
            policy = "accept";
          };

          ssh = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
            protocol = "tcp";
            field = "dport";
            value = config.services.openssh.ports;
            policy = "accept";
          };

          default = entryAfter ["loopback" "established-locally" "basic-icmp6" "basic-icmp" "ping6" "ping"] {
            policy = lib.mkDefault "drop";
          };
        };

        # accept all outgoing traffic
        output = {
          default = entryAnywhere {
            policy = "accept";
          };
        };

        # let nftables forward traffic
        # we decide whether the host can forward traffic
        # via sysctl settings elsewhere
        forward = {
          default = entryAnywhere {
            policy = "accept";
          };
        };
      };
    };
  };
}
