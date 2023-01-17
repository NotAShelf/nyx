{
  config,
  pkgs,
  ...
}: let
  OWNER_EMAIL = "postmaster@example.org"; # Change this!
  MAILMAN_HOST = "mailman.example.org"; # Change this!
in {
  services.postfix = {
    enable = true;
    relayDomains = ["hash:/var/lib/mailman/data/postfix_domains"];
    sslCert = config.security.acme.certs.${MAILMAN_HOST}.directory + "/full.pem";
    sslKey = config.security.acme.certs.${MAILMAN_HOST}.directory + "/key.pem";
    config = {
      transport_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
      local_recipient_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
    };
  };
  # https://nixos.wiki/wiki/Mailman
  services.mailman = {
    enable = true;
    siteOwner = OWNER_EMAIL;
    webUser = config.services.uwsgi.user;
    hyperkitty.enable = true;
    # Have mailman talk directly to hyperkitty, bypassing nginx:
    hyperkitty.baseUrl = "http://localhost:33141/hyperkitty/";
    webHosts = [MAILMAN_HOST];
  };

  # Make sure that uwsgi gets restarted if any django settings change.
  # I'm not sure why this isn't covered by the "before" and
  # "requiredBy" settings present in mailman-web.service. Maybe
  # because it's a oneshot and not a daemon?
  systemd.services.uwsgi.restartTriggers = [
    config.environment.etc."mailman3/settings.py".source
  ];

  # Tweak permissions so nginx can read and serve the static assets
  # (otherwise /var/lib/mailman-web is mode 0600)
  systemd.services.mailman-settings.script = ''
    chmod o+x /var/lib/mailman-web
  '';

  services.uwsgi = {
    enable = true;
    plugins = ["python3"];
    instance = {
      type = "normal";
      pythonPackages = (
        # TODO: I hope there is a nicer way of doing this:
        self:
          with self.override {
            overrides = self: super: {django = self.django_1_11;};
          }; [mailman-web]
      );
      # uwsgi protocol socket for nginx
      socket = "127.0.0.1:33140";
      # http socket for mailman core to reach the hyperkitty API directly
      http-socket = "127.0.0.1:33141";
      wsgi-file = "${config.services.mailman.webRoot}/mailman_web/wsgi.py";
      chdir = "/var/lib/mailman-web";
      master = true;
      processes = 4;
      vacuum = true;
    };
  };

  security.acme.email = OWNER_EMAIL;
  security.acme.acceptTerms = true;

  services.nginx = {
    virtualHosts.${MAILMAN_HOST} = {
      enableACME = true;
      forceSSL = true;
      locations."/static/".alias = "/var/lib/mailman-web/static/";
      # If you're coming from Mailman 2, you might want these redirects:
      # locations."~ ^/(?:pipermail|private)/([a-z-]+)/".return = "303 https://${MAILMAN_HOST}/hyperkitty/list/$1.${MAILMAN_HOST}/";
      # locations."~ ^/(?:listadmin)/([a-z-]+)".return = "303 https://${MAILMAN_HOST}/postorius/lists/$1.${MAILMAN_HOST}/settings/";
      # locations."~ ^/(?:listinfo|options)/([a-z-]+)".return = "303 https://${MAILMAN_HOST}/postorius/lists/$1.${MAILMAN_HOST}/";
      # locations."/create".return = "301 https://${MAILMAN_HOST}/postorius/lists/new";
      locations."/".extraConfig = ''
        uwsgi_pass 127.0.0.1:33140;
        include ${config.services.nginx.package}/conf/uwsgi_params;
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [25 80 443];
}
