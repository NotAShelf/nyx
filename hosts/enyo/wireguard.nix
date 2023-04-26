{
  config,
  lib,
  ...
}: {
  networking = {
    # enable wireguard and add tools
    wireguard.enable = true;

    # ports to be used for wireguard
    firewall.allowedUDPPorts = [51820 51821];

    # wg-quick interfaces, could be named anything
    wg-quick.interfaces = {
      wg0 = {
        privateKeyFile = config.age.secrets.wg-client.path;
        address = ["10.0.0.2/32"];
        dns = ["10.0.0.1"];
        listenPort = 51820;
        peers = [
          {
            # helios
            publicKey = "0qV2U3Dzkkf8plN19Y5pZdBgTY0TNb8BczDwzq65dXg=";
            allowedIPs = ["10.0.0.1/24"];
            endpoint = "notashelf.dev:51820";
            persistentKeepalive = 30;
          }
        ];
      };
    };
    systemd.services.wg-quick-wg0 = {
      serviceConfig = {
        Type = lib.mkForce "simple";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      unitConfig = {
        StartLimitIntervalSec = 0; # ensure Restart= is always honoured
      };
    };
  };
}
