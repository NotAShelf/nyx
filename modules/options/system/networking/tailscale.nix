{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;

  sys = config.modules.system;
  cfg = sys.networking.tailscale;
in {
  options.modules.system.networking.tailscale = {
    enable = mkEnableOption "Tailscale VPN";
    autoLogin = mkEnableOption ''
      systemd-service for bootstrapping a Tailscale connection automatically
    '';

    endpoint = mkOption {
      type = types.str;
      default = "https://hs.notashelf.dev";
      description = ''
        The URL of the Tailscale control server to use. In case you
        would like to use a self-hosted Headscale server, such as
        the default value, you may change this value accordingly.
      '';
    };

    operator = mkOption {
      type = types.str;
      default = sys.mainUser;
      description = ''
        The name of the Tailscale operator to use. This is used to
        avoid using sudo in command-line operations and if set, will
        run the auto-authentication service as the specified user.
      '';
    };

    flags = {
      default = mkOption {
        type = with types; listOf str;
        default = ["--ssh"];
        description = ''
          A list of command-line flags that will be passed to the Tailscale
          daemon automatically when it is started, using
          {option}`config.services.tailscale.extraUpFlags`

          If `isServer` is set to true, the server-specific values will be
          appended to the list defined in this option.
        '';
      };
    };

    isClient = mkOption {
      type = types.bool;
      default = cfg.enable;
      example = true;
      description = ''
        Whether the target host should utilize Tailscale client features";

        This option is mutually exlusive with {option}`tailscale.isServer`
        as they both configure Taiscale, but with different flags
      '';
    };

    isServer = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether the target host should utilize Tailscale server features.

        This option is mutually exlusive with {option}`tailscale.isClient`
        as they both configure Taiscale, but with different flags
      '';
    };
  };
}
