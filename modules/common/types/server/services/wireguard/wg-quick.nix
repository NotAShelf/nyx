{
  config,
  lib,
  ...
}: {
  networking = {
    firewall.allowedUDPPorts = [51820 51821];

    nat.internalInterfaces = ["wg0"];

    wireguard.interfaces = {
      wg0 = {
        ips = ["10.0.0.1/24"];
        listenPort = 51820;
        privateKeyFile = config.age.secrets.wireguard.path;
        peers = [
          {
            # enyo
            publicKey = "vv190fxSVr+u7Zv0ujPcwE4aYs0QcbObHwzWGwUNSUA=";
            allowedIPs = ["10.0.0.2/32"];
          }
          /*
          {
            # test
            publicKey = "";
            allowedIPs = ["10.0.0.3/32"];
          }
          */
        ];
      };
    };
  };
}
