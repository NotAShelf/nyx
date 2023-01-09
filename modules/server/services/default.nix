{
  config,
  pkgs,
  ...
}: {
  imports = [
    #./git
    #./tor
    #./nginx
    #./grafana # TODO
    #./irc # TODO
    #./mailserver # TODO
    #./kodi # https://nixos.wiki/wiki/Kodi
    #./jellyfin # https://nixos.wiki/wiki/Jellyfin
  ];
}
