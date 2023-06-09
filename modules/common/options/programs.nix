{lib, ...}:
with lib; {
  # this module provides overrides for certain defaults and lets you set
  # default programs for referencing in other config files.
  options.modules = {
    services = {
      override = {
        nextcloud = mkEnableOption "Override Nextcloud service";
        mailserver = mkEnableOption "Override nixos-mailserver service";
        mkm = mkEnableOption "Override mkm-ticketing service";
        vaultwarden = mkEnableOption "Override VaultWarden service";
        gitea = mkEnableOption "Override Gitea service";
        grafana = mkEnableOption "Override Grafana and Prometheus services";
        irc = mkEnableOption "Override Quassel IRC service";
        jellyfin = mkEnableOption "Override Jellyfin media service";
        matrix = mkEnableOption "Override Matrix-synapse service";
        wireguard = mkEnableOption "Override Wireguard service";
        searxng = mkEnableOption "Override Searxng service";
        database = {
          mysql = mkEnableOption "Override MySQL database service";
          mongodb = mkEnableOption "Override MongoDB service";
          redis = mkEnableOption "Override Redis service";
          postgresql = mkEnableOption "Override Postgresql service";
        };
      };
    };

    programs = {
      # "override" is a simple option that sets the programs' state to the oppossite of their default
      override = {
        # override basic desktop applications
        # an example override for the libreoffice program
        # if set to true, libreoffice module will not be enabled as it is by default
        libreoffice = mkEnableOption "Override Libreoffice suite";
      };

      # TODO: turn those into overrides
      # load GUI and CLI programs by default, but check if those overrides are enabled
      # so that they can be disabled at will
      cli = {
        enable = mkEnableOption "Enable CLI programs";
      };
      gui = {
        enable = mkEnableOption "Enable GUI programs";
      };

      gaming = {
        enable = mkEnableOption "Enable packages required for the device to be gaming-ready";

        emulation.enable = mkEnableOption "Enable programs required to emulate other platforms";

        chess.enable = mkEnableOption "Chess programs and engines";

        gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = true;};
      };

      git = {
        signingKey = mkOption {
          type = types.str;
          default = "";
          description = "The default gpg key used for signing commits";
        };
      };

      # default program options
      default = {
        # what program should be used as the default terminal
        # do note this is NOT the command, but just the name. i.e setting footclient will
        # not work because the program name will be references as "foot" in the rest of the config
        terminal = mkOption {
          type = types.enum ["foot" "kitty" "wezterm"];
          default = "kitty";
        };

        fileManager = mkOption {
          type = types.enum ["thunar" "dolphin" "nemo"];
          default = "dolphin";
        };

        browser = mkOption {
          type = types.enum ["firefox" "librewolf" "chromium"];
          default = "firefox";
        };

        editor = mkOption {
          type = types.enum ["neovim" "helix" "emacs"];
          default = "neovim";
        };

        launcher = mkOption {
          type = types.enum ["rofi" "wofi" "anyrun"];
          default = "rofi";
        };
      };
    };
  };
}
