{pkgs, ...}: {
  modules.system.boot.kernel = pkgs.linuxPackages_xanmod_latest;
}
