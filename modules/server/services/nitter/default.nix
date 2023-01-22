_: {
  services = {
    # redis setup for nitter
    redis = {
      servers = {
        "nitter" = {
          enable = true;
          port = 6379;
        };
      };
    };

    nitter = {
      # TODO: caching and redis setup
      enable = true;
      openFirewall = true;
    };
  };
}
