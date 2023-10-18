_: {
  imports = [
    ./databases # mariadb and redis, mongo refuses to build
    ./nginx # nginx webserver
    ./forgejo # lightweight git service, fork of gitea
    ./nextcloud # cloud storage (not a backup solution)
    ./wireguard # vpn server - works but I cannot get my system to us the wireguard interface
    ./monitoring # prometheus and grafana
    ./matrix # matrix communication server
    ./vaultwarden # bitwarden compatible password manager
    ./mailserver # nixos-mailserver setup
    ./jellyfin # media server
    ./tor # tor relay
    ./searxng # searx search engine
    ./mkm # holy fuck
    ./mastodon # decentralized social
  ];
}
