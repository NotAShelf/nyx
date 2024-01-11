{
  config.modules.system.services = {
    nextcloud.enable = true;
    mailserver.enable = true;
    vaultwarden.enable = true;
    forgejo.enable = true;
    searxng.enable = true;
    reposilite.enable = true;

    social = {
      mastodon.enable = true;
      matrix.enable = true;
    };

    bincache = {
      harmonia.enable = true;
    };

    networking = {
      headscale.enable = true;
      wireguard.enable = true;
    };

    monitoring = {
      grafana.enable = true;
      prometheus.enable = true;
      loki.enable = true;
      uptime-kuma.enable = true;
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
