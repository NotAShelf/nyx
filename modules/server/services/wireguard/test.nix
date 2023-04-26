{
  config,
  lib,
  ...
}: {
  # Wireguard setup
  networking.wireguard = {
    enable = true;
    interfaces.wg1 = {
      # General settings
      privateKeyFile = config.age.secrets.wg-server.path;
      listenPort = 51820;

      # IPs
      ips = [
        "10.255.255.10/24" # v4 general
        "10.255.255.254/24" # v4 adtl
        "fe80::10/64" # v6 link local
        "2a01:4f9:c010:2cf9:f::10/80" #v6 general
        "2a01:4f9:c010:2cf9:f::ffff/80" #v6 adtl
      ];

      # Peers
      peers = [
        # enyo
        {
          allowedIPs = [
            "10.255.255.11/32"
            "fe80::11/128"
            "2a01:4f9:c010:2cf9:f::11/128"
          ];
          publicKey = "u5Riuu4NEWEH06qATdnrPO+LacZTspoghqMnoWQ+uEQ=";
        }
      ];
    };
  };
}
