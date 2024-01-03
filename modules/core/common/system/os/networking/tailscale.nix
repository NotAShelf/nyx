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

    # enable tailscale, inter-machine VPN service
    services.tailscale = {
      enable = true;
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "both";
      # TODO: these actually need to be specified with `tailscale up`
      extraUpFlags = cfg.defaultFlags ++ optionals cfg.isServer ["--advertise-exit-node"];
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
            ${pkgs.tailscale}/bin/tailscale up -authkey file:${config.age.secrets.tailscale-client.path}
          '';
        };
      };

      network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];
    };
  };
}
