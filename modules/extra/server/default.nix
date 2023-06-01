_: {
  imports = [
    ./programs
    ./services
    ./users.nix
  ];

  config = {
    networking.firewall.allowedTCPPorts = [
      3001 # mkm
    ];
  };
}
