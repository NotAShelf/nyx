{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault optionals mkBefore;
  inherit (config.services) tailscale;

  sys = config.modules.system.networking;
  cfg = sys.tailscale;

  upFlags =
    cfg.flags.default
    ++ ["--authkey file:${config.age.secrets.tailscale-client.path}"]
    ++ optionals cfg.isServer ["--advertise-exit-node"]
    ++ optionals (cfg.endpoint != null) ["--login-server ${cfg.endpoint}"]
    # TODO: test if specifying an operator messes with the autologin service
    # which, as you expect, does not run as the operator user
    ++ optionals (cfg.operator != null) ["--operator" cfg.operator];
in {
  config = mkIf cfg.enable {
    # make the tailscale command usable to users
    environment.systemPackages = [pkgs.tailscale];

    networking.firewall = {
      # always allow traffic from the designated tailscale interface
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";

      # allow
      allowedUDPPorts = [tailscale.port];
    };

    boot.kernel = {
      sysctl = {
        # # Enable IP forwarding
        # required for Wireguard & Tailscale/Headscale subnet feature
        # See <https://tailscale.com/kb/1019/subnets/?tab=linux#step-1-install-the-tailscale-client>
        "net.ipv4.ip_forward" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };
    };

    # enable tailscale, inter-machine VPN service
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "both";
      # TODO: these flags still need to be specified with `tailscale up`
      # for some reason
      extraUpFlags = upFlags;
    };

    systemd = {
      services = {
        # lets not send our logs to log.tailscale.io
        # unless I get to know what they do with the logs
        tailscaled.serviceConfig.Environment = mkBefore ["TS_NO_LOGS_NO_SUPPORT=true"];

        # oneshot tailscale authentication servcie
        # TODO: this implies tailscale has been authenticated before with our own login server
        # ideally we should have a way to authenticate tailscale with our own login server in
        # this service, likely through an option in the system module
        tailscale-autoconnect = {
          description = "Automatic connection to Tailscale";

          # make sure tailscale is running before trying to connect to tailscale
          after = ["network-pre.target" "tailscale.service"];
          wants = ["network-pre.target" "tailscale.service"];
          wantedBy = ["multi-user.target"];

          # set this service as a oneshot job
          serviceConfig.Type = "oneshot";

          # have the job run this shell script
          script = ''
            # wait for tailscaled to settle
            sleep 2

            # check if we are already authenticated to tailscale
            status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
            if [ $status = "Running" ]; then # if so, then do nothing
              exit 0
            fi

            # otherwise authenticate with tailscale
            ${pkgs.tailscale}/bin/tailscale up ${toString upFlags}
          '';
        };
      };

      network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];
    };
  };
}
