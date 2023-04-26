{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg1 = {
      ips = [
        "10.255.255.11/32"
        "2a01:4f9:c010:2cf9:f::11/128"
      ];
      peers = [
        {
          allowedIPs = [
            "10.255.255.0/24"
            "2a01:4f9:c010:2cf9:f::/80"
          ];
          endpoint = "notashelf.dev:51820";
          publicKey = "v3ol3QsgLPudVEtbETByQ0ABAOrJE2WcFfQ/PQAD8FM=";
        }
      ];
      privateKeyFile = config.age.secrets.wg-client.path;
      allowedIPsAsRoutes = true;
    };
  };
}
