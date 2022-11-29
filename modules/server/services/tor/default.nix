{
  pkgs,
  lib,
  config,
  ...
}: {
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
}
