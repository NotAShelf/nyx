{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.tor.enable {
    services = {
      tor.settings = {
        AutomapHostsOnResolve = true;
        AutomapHostsSuffixes = [".exit" ".onion"];
        EnforceDistinctSubnets = true;
        ExitNodes = "{pl}";
        EntryNodes = "{pl}";
        NewCircuitPeriod = 120;
        DNSPort = 9053;
        BandWidthRate = "15 MBytes";
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
