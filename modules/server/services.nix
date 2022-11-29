{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    # Enable cron service
    cron = {
      enable = true;
      systemCronJobs = [
        "*/50 * * * *      root    date >> /tmp/cron.log"
      ];
    };
  };
}
