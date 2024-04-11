{
  networking.firewall.allowedUDPPorts = [123];

  # free, easy-to-use implementation of the Network Time Protocol
  # available as a part of the OpenBSD projeect.
  # since BSDs are known for their superior networking stack, this
  # might provide better performance than the defaults
  services.openntpd = {
    enable = true;
    servers = [
      "0.tr.pool.ntp.org"
      "1.tr.pool.ntp.org"
      "2.tr.pool.ntp.org"
      "3.tr.pool.ntp.org"
    ];

    extraConfig = ''
      listen on *
    '';
  };
}
