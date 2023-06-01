_: {
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://vault.notashelf.dev";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
      };
      backupDir = "/opt/vault";
    };
  };
}
