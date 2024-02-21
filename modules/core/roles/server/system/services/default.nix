{
  imports = [
    # essentials
    ./databases # mysql, postgreqsl, redis and more
    ./nginx # base nginx webserver configuration

    # other services
    ./bincache # atticd and harmonia
    ./monitoring # prometheus, grafana, loki and uptime-kuma
    ./networking # wireguard and headscale
    ./social # mastodon and matrix
    ./forgejo.nix # lightweight git service, fork of gitea
    ./forgejo-runner.nix # self-hosted runner for forgejo
    ./nextcloud.nix # cloud storage (not a backup solution)
    ./vaultwarden.nix # bitwarden compatible password manager
    ./mailserver.nix # nixos-mailserver setup
    ./jellyfin.nix # media server
    ./tor.nix # tor relay
    ./searxng.nix # searx search engine
    ./reposilite.nix # self-hosted maven repository
    ./elasticsearch.nix # elasticsearch
    ./kanidm.nix # kanidm identity management

    # misc
    ./mkm.nix # holy fuck
  ];
}
