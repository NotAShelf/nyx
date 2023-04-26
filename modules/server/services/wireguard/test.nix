{...}: {
  networking = {
    firewall = {
      allowedUDPPorts = [
        5553 # wireguard
      ];
    };

    nat.internalInterfaces = ["wg0"];

    wireguard.interfaces = {
      wg0 = {
        ips = ["10.0.0.1/24"];
        listenPort = 5553;
        privateKeyFile = "/root/wg-private";
        peers = [
          {
            # enyo
            publicKey = "vv190fxSVr+u7Zv0ujPcwE4aYs0QcbObHwzWGwUNSUA=";
            allowedIPs = ["10.0.0.2/32"];
          }
          /*
          {
            # neodymium
            publicKey = "IFeRvelEilNRLkhWgFKL9HrJ9XYsm+r4yvv23CigETk=";
            allowedIPs = ["10.0.0.3/32"];
          }
          */
        ];
      };
    };
  };
}
