_: {
  imports = [
    ./databases # mariadb and redis, mongo refuss to build
    ./nginx # nginx webserver
    ./gitea # lightweight git service
    ./nextcloud # cloud storage (not a backup solution)
    ./wireguard # vpn server - works but I cannot get my system to us the wireguard interface
    ./monitoring # prometheus and grafana
    ./matrix # matrix communication server
    ./vaultwarden # bitwarden compatible password manager
    ./mailserver # nixos-mailserver setup
    ./jellyfin # media server
    ./tor # tor relay
    ./searxng # searx search engine
    # ./mkm # holy fuck
  ];
}
