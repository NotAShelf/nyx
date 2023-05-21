_: {
  imports = [
    ./nginx
    ./gitea
    ./nextcloud
    ./wireguard
    ./grafana
    ./matrix
    ./vaultwarden
    ./mailserver
    ./jellyfin # https://nixos.wiki/wiki/Jellyfin

    #./tor
    #./irc # TODO
  ];
}
