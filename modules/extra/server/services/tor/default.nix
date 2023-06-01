{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      tor.settings = {
        DnsPort = 9053;
        AutomapHostsOnResolve = true;
        AutomapHostsSuffixes = [".exit" ".onion"];
        EnforceDistinctSubnets = true;
        ExitNodes = "{pl}";
        EntryNodes = "{pl}";
        NewCircuitPeriod = 120;
        DNSPort = 9053;
      };

      # tor.relay.onionServices = {
      #   # hide ssh from script kiddies
      #   ssh = {
      #     version = 3;
      #     map = [{port = 22;}];
      #   };
      #   # feds crying rn
      #   website = {
      #     version = 3;
      #     map = [{port = 80;}];
      #   };
      # };
    };
  };
}
