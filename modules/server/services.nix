{
  config,
  pkgs,
  lib,
  ...
}: {
  # let spotifyd be discovered
  networking.firewall.allowedTCPPorts = [57621];

  services = {
    # Enable cron service
    cron = {
      enable = true;
      systemCronJobs = [
        "*/50 * * * *      root    date >> /tmp/cron.log"
      ];
    };

    spotifyd.enable = true;
  };
}
