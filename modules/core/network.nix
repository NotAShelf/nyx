{
  config,
  pkgs,
  ...
}: {
  networking = {
    # dns
    nameservers = ["1.1.1.1" "1.0.0.1"];

    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [443 80 22];
      allowedUDPPorts = [443 80 9100];
      allowPing = false;
      logReversePathDrops = true;
    };
  };
}
