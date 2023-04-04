_: {
  networking.firewall = {
    allowedUDPPorts = [60247]; # Clients and peers can use the same port, see listenport
    checkReversePath = "loose";
  };

  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = ["10.66.66.2/32" "fd42:42:42::2/128"];
      listenPort = 60247; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      privateKeyFile = "/persist/passwords/wg0-notashelf.key";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "2P4YmoHCogwk6cl9riC1cVPZysmpe7gKI6OCLxE4w3Q=";
          presharedKeyFile = "/persist/passwords/wg0-notashelf-preshared.key";

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0" "::/0"];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "168.119.231.67:60247";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
