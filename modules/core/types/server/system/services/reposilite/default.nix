# this ABSOLUTELY needs a nixos module
{self', ...}: {
  config = {
    services.reposilite = {
      enable = true;
      package = self'.packages.reposilite;

      settings = {
        user = "reposilite";
        group = "reposilite";

        port = 8084;
        dataDir = "/srv/storage/reposilite";
      };
    };
  };
}
