{pkgs, ...}: {
  environment.systemPackages = [pkgs.wireguard-tools];
}
