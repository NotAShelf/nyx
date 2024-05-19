{
  config,
  lib,
  ...
}: let
  inherit (builtins) concatStringsSep;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.lists) optionals concatLists;
  inherit (lib.types) str listOf bool nullOr;

  sys = config.modules.system;
  cfg = sys.networking.tailscale;
in {
  options.modules.system.networking.tailscale = {
    enable = mkEnableOption "Tailscale inter-machine VPN service";
    autoLogin = mkEnableOption ''
      the tailscale-autologin systemd-service for bootstrapping a Tailscale
      connection automatically
    '';

    endpoint = mkOption {
      type = str;
      default = "https://hs.notashelf.dev";
      description = ''
        The URL of the Tailscale control server to use. In case you
        would like to use a self-hosted Headscale server, such as
        the default value, you may change this value accordingly.
      '';
    };

    operator = mkOption {
      type = str;
      default = sys.mainUser;
      description = ''
        The name of the Tailscale operator to use. This is used to
        avoid using sudo in command-line operations and if set, will
        run the auto-authentication service as the specified user.
      '';
    };

    authkey = mkOption {
      type = nullOr str;
      default = config.age.secrets.tailscale-client.path;
      description = ''
        The path to the Tailscale authentication key file.

        This is used to authenticate the target host with the
        Tailscale coordination server.

        ::: {.warning}
        It *is* possible to use a single key for multiple hosts
        but for security and auditing purposes, I would advise
        against doing so.
        :::
      '';
    };

    flags = {
      default = mkOption {
        type = listOf str;
        default = ["--ssh"];
        description = ''
          A list of command-line flags that will be passed to the Tailscale
          daemon automatically when it is started, using
          {option}`config.services.tailscale.extraUpFlags`

          If `isServer` is set to true, the server-specific values will be
          appended to the list defined in this option.
        '';
      };

      final = mkOption {
        type = listOf str;
        internal = true;
        readOnly = true;
        default = concatLists [
          cfg.flags.default
          (optionals (cfg.authkey != null) ["--authkey file:${config.age.secrets.tailscale-client.path}"])
          (optionals (cfg.endpoint != null) ["--login-server" "${cfg.endpoint}"])
          (optionals (cfg.operator != null) ["--operator ${cfg.operator}"])
          (optionals (cfg.tags != []) ["--advertise-tags" (concatStringsSep "," cfg.tags)])
          (optionals cfg.isServer ["--advertise-exit-node"])
        ];

        description = ''
          The constructed command-line argument string that will be
          passed to Tailscaled or the tailscale-autologin service.
        '';
      };
    };

    tags = mkOption {
      type = listOf str;
      default =
        if cfg.isClient
        then ["tag:client"]
        else if cfg.isServer
        then ["tag:server"]
        else [];

      defaultText = ''
        If host advertises itself as a client, the default value will be
        `["tag:client"]`, and if it advertises itself as a server, the default
        value will be `["tag:server"]`.

        If neither `isClient` nor `isServer` is set, the default value will be
        an empty list.
      '';

      description = ''
        A list of tags that will be assigned to the target host using
        the "force advertise tags" feature of Tailscale. This will
        be used by the Headscale control server to set up ACLs.
      '';
    };

    isClient = mkOption {
      type = bool;
      default = cfg.enable;
      example = true;
      description = ''
        Whether the target host should utilize Tailscale client features";

        This option is mutually exclusive with {option}`tailscale.isServer`
        as they both configure Taiscale, but with different flags
      '';
    };

    isServer = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Whether the target host should utilize Tailscale server features.

        This option is mutually exclusive with {option}`tailscale.isClient`
        as they both configure Taiscale, but with different flags
      '';
    };
  };
}
