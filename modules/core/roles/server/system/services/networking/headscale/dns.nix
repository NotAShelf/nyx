{
  services.headscale.settings.dns_config = {
    override_local_dns = true;
    magic_dns = true;
    base_domain = "notashelf.dev";
    domains = [];
    nameservers = [
      "9.9.9.9" # no cloudflare, nice
    ];

    /*
    extra_records = [
      {
        name = "idm.notashelf.dev";
        type = "A";
        value = "100.64.0.1"; # NOTE: this should be the address of the "host" node - which is the server
      }
    ];
    */
  };
}
