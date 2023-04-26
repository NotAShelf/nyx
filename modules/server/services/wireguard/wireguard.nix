{
  config,
  pkgs,
  ...
}: {
  # this usually needs a reboot before the service can use the kernel module
  boot.kernelModules = ["wireguard"];

  networking = {
    nat = {
      enable = true;
      externalInterface = "enp0s3";
      internalInterfaces = ["wg0"];
    };
    wireguard.interfaces.wg0 = {
      ips = ["10.0.0.1/24"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard.path;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o ens3 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.0.0/24 -o ens3 -j MASQUERADE
      '';
      peers = [
        {
          # desktop
          publicKey = "vv190fxSVr+u7Zv0ujPcwE4aYs0QcbObHwzWGwUNSUA=";
          allowedIPs = ["10.0.0.2/32"];
        }
      ];
    };
  };
}