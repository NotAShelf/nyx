{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  # this module provides a set of options for commonly used programs
  # and leaves it to the host to enable or disable them
  options.modules = {
    services = {
      nextcloud.enable = mkEnableOption "Enable Nextcloud service";
      mailserver.enable = mkEnableOption "Enable nixos-mailserver service";
      mkm.enable.enable = mkEnableOption "Enable mkm-ticketing service";
      vaultwarden.enable = mkEnableOption "Enable VaultWarden service";
      gitea.enable = mkEnableOption "Enable Gitea service";
      grafana.enable = mkEnableOption "Enable Grafana and Prometheus services";
      irc.enable = mkEnableOption "Enable Quassel IRC service";
      jellyfin.enable = mkEnableOption "Enable Jellyfin media service";
      matrix.enable = mkEnableOption "Enable Matrix-synapse service";
      wireguard.enable = mkEnableOption "Enable Wireguard service";
      searxng.enable = mkEnableOption "Enable Searxng service";
      database = {
        mysql.enable = mkEnableOption "Enable MySQL database service";
        mongodb.enable = mkEnableOption "Enable MongoDB service";
        redis.enable = mkEnableOption "Enable Redis service";
        postgresql.enable = mkEnableOption "Enable Postgresql service";
      };
    };

    programs = {
      libreoffice.enable = mkEnableOption "Enable Libreoffice suite";
      chromium.enable = mkEnableOption "Enable Chromium browser";
      thunderbird.enable = mkEnableOption "Enable Thunderbird mail client";
      vscode.enable = mkEnableOption "Enable Visual Studio Code";
      obs.enable = mkEnableOption "Enable OBS Studio";
      spotify.enable = mkEnableOption "Enable Spotify";
      zathura.enable = mkEnableOption "Enable Zathura document viewer";
      steam.enable = mkEnableOption "Enable Steam";
      mangohud.enable = mkEnableOption "Enable MangoHud" // {default = config.modules.programs.steam.enable;};

      firefox = {
        enable = mkEnableOption "Enable Firefox";
        client = mkOption {
          # schizofox is a heavy patched version of Firefox with a lot of privacy features
          # https://github.com/schizofox/schizofox
          type = types.enum ["default" "schizofox"];
          default = "schizofox"; # never take your meds
          description = "The Firefox module to be used";
        };
      };

      discord = {
        enable = mkEnableOption "Enable Discord messenger";
        client = mkOption {
          type = types.enum ["stable" "canary" "webcord"];
          default = "webcord";
          description = "The Discord client to be used";
        };
      };
    };
  };
}
