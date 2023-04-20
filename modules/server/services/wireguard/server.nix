{
  config,
  lib,
  pkgs,
  ...
}: {
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = ["wg0"];
  networking.firewall = {
    allowedUDPPorts = [51820];
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg0 = {
        # Determines the IP address and subnet of the server's end of the tunnel interface.
        ips = ["10.100.0.1/24"];

        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = 51820;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';

        # Path to the private key file.
        privateKeyFile = config.age.secrets.wireguard.path;

        peers = [
          # List of allowed peers.
          {
            # Feel free to give a meaning full name
            # Public key of the peer (not a file path).
            publicKey = "{client public key}";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = ["10.100.0.2/32"];
          }
          {
            # John Doe
            publicKey = "{john doe's public key}";
            allowedIPs = ["10.100.0.3/32"];
          }
        ];
      };
    };
  };
}
