{lib, ...}: let
  inherit (lib) entryBetween;
in {
  networking.nftables.rules = {
    inet.filter.input = {
      headscale = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        value = 8085;
        policy = "accept";
      };

      searxng = entryBetween ["basic-icmp6" "basic-icmp" "ping6" "ping"] ["default"] {
        protocol = "tcp";
        field = "dport";
        value = 8888;
        policy = "accept";
      };
    };
  };
}
