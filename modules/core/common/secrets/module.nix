{
  config,
  lib,
  ...
}: let
  inherit (lib) mkAgenixSecret;
  inherit (lib.strings) optionalString;

  sys = config.modules.system;
  cfg = sys.services;
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets = {
    # TODO: system option for declaring host as a potential builder
    nix-builderKey = mkAgenixSecret true {
      file = "common/nix-builder.age";
    };

    tailscale-client = mkAgenixSecret true {
      file = "client/tailscale.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    # secrets needed for peers
    spotify-secret = mkAgenixSecret sys.programs.spotify.enable {
      file = "client/spotify.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    wg-client = mkAgenixSecret true {
      file = "client/wg.age";
      owner = "notashelf";
      group = "users";
      mode = "700";
    };

    client-email = mkAgenixSecret true {
      file = "client/email.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    # database secrets
    mongodb-secret = mkAgenixSecret cfg.database.mongodb.enable {
      file = "db/mongodb.age";
    };

    garage-env = mkAgenixSecret cfg.database.garage.enable {
      file = "db/garage.age";
      mode = "400";
      owner = "garage";
      group = "garage";
    };

    # service secrets
    wg-server = mkAgenixSecret cfg.networking.wireguard.enable {
      file = "service/wg.age";
    };

    mkm-web = mkAgenixSecret cfg.mkm.enable {
      file = "service/mkm-web.age";
      mode = "400";
    };

    matrix-secret = mkAgenixSecret cfg.social.matrix.enable {
      file = "service/matrix.age";
      owner = "matrix-synapse";
      mode = "400";
    };

    vaultwarden-env = mkAgenixSecret cfg.vaultwarden.enable {
      file = "service/vaultwarden.age";
      owner = "vaultwarden";
      mode = "400";
    };

    searx-secretkey = mkAgenixSecret cfg.searxng.enable {
      file = "service/searx.age";
      mode = "400";
      owner = "searx";
      group = "searx";
    };

    nextcloud-secret = mkAgenixSecret cfg.nextcloud.enable {
      file = "service/nextcloud.age";
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };

    attic-env = mkAgenixSecret cfg.bincache.atticd.enable {
      file = "service/attic.age";
      mode = "400";
      owner = "atticd";
      group = "atticd";
    };

    harmonia-privateKey = mkAgenixSecret cfg.bincache.harmonia.enable {
      file = "service/harmonia.age";
      mode = "770";
      owner = "harmonia";
      group = "harmonia";
    };

    forgejo-runner-token = mkAgenixSecret cfg.forgejo.enable {
      file = "service/forgejo-runner-token.age";
      mode = "400";
      owner = "gitea-runner";
      group = "gitea-runner";
    };

    forgejo-runner-config = mkAgenixSecret cfg.forgejo.enable {
      file = "service/forgejo-runner-config.age";
      mode = "400";
      owner = "gitea-runner";
      group = "gitea-runner";
    };

    headscale-derp = mkAgenixSecret cfg.networking.headscale.enable {
      file = "service/headscale-derp.age";
      mode = "400";
      owner = "headscale";
      group = "headscale";
    };

    headscale-noise = mkAgenixSecret cfg.networking.headscale.enable {
      file = "service/headscale-noise.age";
      mode = "400";
      owner = "headscale";
      group = "headscale";
    };

    # mailserver secrets
    mailserver-secret = mkAgenixSecret cfg.mailserver.enable {
      file = "mailserver/postmaster.age";
      mode = "400";
    };

    mailserver-forgejo-secret = mkAgenixSecret cfg.forgejo.enable {
      file = "mailserver/forgejo.age";
      owner = "forgejo";
      group = "forgejo";
      mode = "400";
    };

    mailserver-vaultwarden-secret = mkAgenixSecret cfg.vaultwarden.enable {
      file = "mailserver/vaultwarden.age";
      owner = "vaultwarden";
      mode = "400";
    };

    mailserver-cloud-secret = mkAgenixSecret cfg.nextcloud.enable {
      file = "mailserver/cloud.age";
      owner = "nextcloud";
      mode = "400";
    };

    mailserver-matrix-secret = mkAgenixSecret cfg.social.matrix.enable {
      file = "mailserver/matrix.age";
      owner = "matrix-synapse";
      mode = "400";
    };

    mailserver-noreply-secret = mkAgenixSecret cfg.social.mastodon.enable {
      file = "mailserver/noreply.age";
      owner = "mastodon";
      mode = "400";
    };
  };
}
