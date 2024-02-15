{
  self,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf optionalString;

  sys = config.modules.system;
  cfg = sys.services;

  # mkSecret is an abstraction over agenix secrets
  # it allows for secrets to be written conditionally and with
  # relatively secure defaults without having to set each one of them
  # manually.
  mkSecret = enableCondition: {
    file,
    owner ? "root",
    group ? "root",
    mode ? "400",
  }:
    mkIf enableCondition {
      file = "${self}/secrets/${file}";
      inherit group owner mode;
    };
in {
  age.identityPaths = [
    "${optionalString sys.impermanence.root.enable "/persist"}/etc/ssh/ssh_host_ed25519_key"
    "${optionalString sys.impermanence.home.enable "/persist"}/home/notashelf/.ssh/id_ed25519"
  ];

  age.secrets = {
    # TODO: system option for declaring host as a potential builder
    nix-builderKey = mkSecret true {
      file = "common-nix-builder.age";
    };

    tailscale-client = mkSecret true {
      file = "client-tailscale.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    # secrets needed for peers
    spotify-secret = mkSecret config.modules.system.programs.spotify.enable {
      file = "client-spotify.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    wg-client = mkSecret true {
      file = "client-wg.age";
      owner = "notashelf";
      group = "users";
      mode = "700";
    };

    client-email = mkSecret true {
      file = "client-email.age";
      owner = "notashelf";
      group = "users";
      mode = "400";
    };

    # database secrets
    mongodb-secret = mkSecret cfg.database.mongodb.enable {
      file = "db-mongodb.age";
    };

    garage-env = mkSecret cfg.database.garage.enable {
      file = "db-garage.age";
      mode = "400";
      owner = "garage";
      group = "garage";
    };

    # service secrets
    wg-server = mkSecret cfg.networking.wireguard.enable {
      file = "service-wg.age";
    };

    mkm-web = mkSecret cfg.mkm.enable {
      file = "service-mkm-web.age";
      mode = "400";
    };

    matrix-secret = mkSecret cfg.social.matrix.enable {
      file = "service-matrix.age";
      owner = "matrix-synapse";
      mode = "400";
    };

    vaultwarden-env = mkSecret cfg.vaultwarden.enable {
      file = "service-vaultwarden.age";
      owner = "vaultwarden";
      mode = "400";
    };

    searx-secretkey = mkSecret cfg.searxng.enable {
      file = "service-searx.age";
      mode = "400";
      owner = "searx";
      group = "searx";
    };

    nextcloud-secret = mkSecret cfg.nextcloud.enable {
      file = "service-nextcloud.age";
      mode = "400";
      owner = "nextcloud";
      group = "nextcloud";
    };

    attic-env = mkSecret cfg.bincache.atticd.enable {
      file = "service-attic.age";
      mode = "400";
      owner = "atticd";
      group = "atticd";
    };

    harmonia-privateKey = mkSecret cfg.bincache.harmonia.enable {
      file = "service-harmonia.age";
      mode = "770";
      owner = "harmonia";
      group = "harmonia";
    };

    forgejo-runner-token = mkSecret cfg.forgejo.enable {
      file = "service-forgejo-runner-token.age";
      mode = "400";
      owner = "gitea-runner";
      group = "gitea-runner";
    };

    forgejo-runner-config = mkSecret cfg.forgejo.enable {
      file = "service-forgejo-runner-config.age";
      mode = "400";
      owner = "gitea-runner";
      group = "gitea-runner";
    };

    # mailserver secrets
    mailserver-secret = mkSecret cfg.mailserver.enable {
      file = "mailserver-postmaster.age";
      mode = "400";
    };

    mailserver-forgejo-secret = mkSecret cfg.forgejo.enable {
      file = "mailserver-forgejo.age";
      owner = "forgejo";
      group = "forgejo";
      mode = "400";
    };

    mailserver-vaultwarden-secret = mkSecret cfg.vaultwarden.enable {
      file = "mailserver-vaultwarden.age";
      owner = "vaultwarden";
      mode = "400";
    };

    mailserver-cloud-secret = mkSecret cfg.nextcloud.enable {
      file = "mailserver-cloud.age";
      owner = "nextcloud";
      mode = "400";
    };

    mailserver-matrix-secret = mkSecret cfg.social.matrix.enable {
      file = "mailserver-matrix.age";
      owner = "matrix-synapse";
      mode = "400";
    };

    mailserver-noreply-secret = mkSecret cfg.social.mastodon.enable {
      file = "mailserver-noreply.age";
      owner = "mastodon";
      mode = "400";
    };
  };
}
