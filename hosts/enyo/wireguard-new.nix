{
  config,
  lib,
  ...
}: {
  # wireguard vpn
  networking.wg-quick.interfaces = {
    wg0 = {
      privateKeyFile = config.age.secrets.wg-client.path;
      address = ["10.0.0.2/32"];
      dns = ["10.0.0.1"];
      peers = [
        {
          # helios
          publicKey = "0qV2U3Dzkkf8plN19Y5pZdBgTY0TNb8BczDwzq65dXg=";
          allowedIPs = ["10.0.0.1/24"];
          endpoint = "notashelf.dev:5533";
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
}
