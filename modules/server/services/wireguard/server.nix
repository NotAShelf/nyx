{
  config,
  pkgs,
  ...
}: {
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = ["wg0"];
    };
    wireguard.interfaces.wg0 = {
      ips = ["10.100.0.1/24" "fdc9:281f:04d7:9ee9::1/64"];
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
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKAYCaA6JEnTt2BI6MJn8t2Qc3E45ARZua1VWhQpSPQi root@enyo
";
          allowedIPs = ["10.100.0.2/32"];
        }
      ];
    };
  };
}
