{config, ...}: {
  services = {
    elasticsearch.enable = true;
    services.postgresql.enable = true;

    mastodon = {
      enable = true;
      configureNginx = true;
      localDomain = "social.notashelf.com";
      smtp = {
        authenticate = true;
        createLocally = false;
        fromAddress = "noreply@notashelf.dev";
        user = "noreply";
        host = "mail.notashelf.dev";
        passwordFile = config.age.secrets.mailserver-noreply-secret.path;
      };
      # extra config
      extraConfig = {
        SINGLE_USER_MODE = "true";
        WEB_DOMAIN = "mastodon.${config.services.mastodon.localDomain}";
      };
    };
  };

  # make sure the ports are open
  networking.firewall.allowedTCPPorts = [80 443];
}
