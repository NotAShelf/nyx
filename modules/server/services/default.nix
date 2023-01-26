{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gitea
    ./tor
    ./nginx
    ./grafana # TODO
    ./irc # TODO
    ./jellyfin # https://nixos.wiki/wiki/Jellyfin
    #./kodi # https://nixos.wiki/wiki/Kodi
  ];
}
