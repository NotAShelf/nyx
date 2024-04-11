{
  services.headscale.settings.derp = {
    server = {
      enabled = true;
      stun_listen_addr = "0.0.0.0:3478";

      # Region code and name are displayed in the Tailscale UI to identify a DERP region
      region_code = "headscale";
      region_name = "Headscale Embedded DERP";
      region_id = 999;
    };

    urls = [];
    paths = [];

    auto_update_enabled = false;
    update_frequency = "6h";
  };
}
