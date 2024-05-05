{
  perSystem = {pkgs, ...}: {
    apps = {
      prefetch-url-sha256 = import ./prefetch-url-sha256 {inherit pkgs;};
      build-all-hosts = import ./build-all-hosts {inherit pkgs;};
      check-restart = import ./check-restart {inherit pkgs;};
      upgrade-postgresql = import ./upgrade-postgresql {inherit pkgs;};
    };
  };
}
