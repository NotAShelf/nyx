{
  config,
  lib,
  ...
}: {
  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
    checkReversePath = false;
  };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = ["10.0.0.2/24"];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      privateKeyFile = config.age.secrets.wg-client.path;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "0qV2U3Dzkkf8plN19Y5pZdBgTY0TNb8BczDwzq65dXg=";

          allowedIPs = ["10.0.0.1/32];

          # Set this to the server IP and port.
          endpoint = "128.140.91.216:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
