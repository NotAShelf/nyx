{lib, ...}: let
  inherit (lib) entryBetween;
in {
  networking.nftables.rules = {
    inet.filter.input = {
      # this allows nginx to respond to the domain challenges without passing each service through the firewall
      https = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        value = [443];
        policy = "accept";
      };
    };
  };
}
