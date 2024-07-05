{lib, ...}: let
  inherit (lib) entryBetween;
in {
  networking.nftables.rules = {
    inet.filter.input = {
      # Endless
      endlessh = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        policy = "accept";
        value = [22];
      };

      # Allow nginx to respond to the domain challenges
      # without passing each service through the firewall
      https = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        value = [443];
        policy = "accept";
      };

      # Headscale DERP server should be reachable from outside to allow registering
      # new devices on the Tailnet.
      headscale = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "udp";
        field = "dport";
        policy = "accept";
        value = [3478];
      };

      # Ports needed by Forgejo's internal services
      forgejo = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        policy = "accept";
        value = [2222];
      };

      # NOTE: snm has an option to enable firewall ports by default, but my nftables abstractions
      # do not allow for us to use that option, so we'll just open the ports manually
      # I could probably add an entry that propagates the tcpPorts option to the firewall
      # but that does not seem like a very good option since we'll not be able to control policies
      simple-nixos-mailserver = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        policy = "accept";
        value = [
          25 # smtp
          80 # used for acme-nginx domain challenges
          143 # imap
          993 # imapSsl
          465 # smtpSsl
        ];
      };
    };
  };
}
