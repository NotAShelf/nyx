_: {
  imports = [
    ./nginx
    ./gitea
    ./nextcloud
    ./wireguard
    ./grafana
    ./matrix
    ./vaultwarden
    ./jellyfin # https://nixos.wiki/wiki/Jellyfin

    #./tor
    #./irc # TODO
    #./kodi # https://nixos.wiki/wiki/Kodi
  ];
}
