{
  systemd.network.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking = {
    useDHCP = false;
    networkmanager.enable = false;
    firewall = {
      enable = true;
    };
  };
}
