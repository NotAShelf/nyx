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
      tor = {
        settings = {
          AutomapHostsOnResolve = true;
          AutomapHostsSuffixes = [".exit" ".onion"];
          EnforceDistinctSubnets = true;
          ExitNodes = "{de}";
          EntryNodes = "{de}";
          NewCircuitPeriod = 120;
          DNSPort = 9053;
          BandWidthRate = "15 MBytes";
        };

        relay.onionServices = {
          # hide ssh from script kiddies
          ssh = {
            version = 3;
            map = [{port = builtins.elemAt config.services.openssh.ports 0;}];
          };
        };
      };
    };
  };
}
