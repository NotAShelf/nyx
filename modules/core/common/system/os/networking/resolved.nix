{
  services = {
    resolved = {
      # enable systemd DNS resolver daemon
      enable = true;

      # this is necessary to get tailscale picking up your headscale instance
      # and allows you to ping connected hosts by hostname
      domains = ["~."];

      # DNSSEC provides to DNS clients (resolvers) origin authentication of DNS data, authenticated denial of existence
      # and data integrity but not availability or confidentiality.
      # this is considered EXPERIMENTAL and UNSTABLE according to upstream
      # PLEASE SEE <https://github.com/systemd/systemd/issues/25676#issuecomment-1634810897>
      # before you decide to set this. I have it set to false as the issue
      # does not inspire confidence in systemd's ability to manage this
      dnssec = "false";

      # additional configuration to be appeneded to systemd-resolved configuration
      extraConfig = ''
        # <https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS>
        # apparently upstream (systemd) recommends this to be false
        # `allow-downgrade` is vulnerable to downgrade attacks
        DNSOverTLS=yes # or allow-downgrade
      '';

      # ideally our fallbackDns should be something more widely available
      # but I do not want my last resort to sell my data to every company available
      # NOTE: DNS fallback is not a recovery DNS
      # See <https://github.com/systemd/systemd/issues/5771#issuecomment-296673115>
      fallbackDns = ["9.9.9.9"];
    };
  };
}
