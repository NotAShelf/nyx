{
  perSystem = {pkgs, ...}: let
    callApps = path: import (path + /app.nix) {inherit pkgs;};
  in {
    apps = {
      prefetch-url-sha256 = callApps ./prefetch-url-sha256;
      build-all-hosts = callApps ./build-all-hosts;
      check-restart = callApps ./check-restart;
      mount-local-disks = callApps ./mount-local-disks;
      upgrade-postgresql = callApps ./upgrade-postgresql;
      check-store-errors = callApps ./check-store-errors;
    };
  };
}
