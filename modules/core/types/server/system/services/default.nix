_: {
  imports = [
    # essentials
    ./databases # mysql, postgreqsl, redis and more
    ./nginx # nginx webserver

    # other services
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
    ./mastodon # decentralized social
    ./reposilite # self-hosted maven repository
    ./headscale # tailscale server

    # misc
    ./mkm # holy fuck
  ];
}
