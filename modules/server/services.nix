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

    spotifyd = {
      enable = false;
      package = pkgs.spotifyd.override {
        withKeyring = true;
        withMpris = true;
        withPulseAudio = true;
      };
      settings = {
        global = {
          backend = "pulseaudio";
          bitrate = 320;
          use_mpris = true;
          username = "email for spotify"; # TODO: bind new email to spotify
          password_cmd = "cat <password file>"; # TODO: secret encryption w/ ragenix
        };
      };
    };
  };
}
