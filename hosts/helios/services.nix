_: {
  modules.system.services = {
    nextcloud.enable = true;
    mailserver.enable = true;
    vaultwarden.enable = true;
    forgejo.enable = true;
    matrix.enable = true;
    wireguard.enable = true;
    searxng.enable = true;
    mastodon.enable = true;

    monitoring = {
      grafana.enable = true;
      prometheus.enable = true;
    };

    database = {
      mysql.enable = false;
      mongodb.enable = false;
      redis.enable = true;
      postgresql.enable = true;
      garage.enable = true;
    };
  };
}
