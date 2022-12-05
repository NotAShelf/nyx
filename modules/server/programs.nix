{
  config,
  pkgs,
  inputs,
  ...
}: {
  # TODO: add server specific programs here
  networking.firewall.allowedTCPPorts = [57621];
  services.spotifyd.enable = true;
}
