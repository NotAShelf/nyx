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
      ips = ["10.0.0.1/24" "fdc9:281f:04d7:9ee9::1/64"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wireguard.path;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      peers = [
        {
          # desktop
          publicKey = "vv190fxSVr+u7Zv0ujPcwE4aYs0QcbObHwzWGwUNSUA=";
          allowedIPs = ["10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64"];
        }
      ];
    };
  };
}
