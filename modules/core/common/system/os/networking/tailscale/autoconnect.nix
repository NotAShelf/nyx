{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkBefore;
  inherit (config.services) tailscale;

  sys = config.modules.system;
  cfg = sys.networking.tailscale;
in {
  config = mkIf cfg.enable {
    systemd.services = {
      tailscaled.serviceConfig.Environment = mkBefore [
        # lets not send our logs to log.tailscale.io
        # unless I get to know what they do with the logs
        "TS_NO_LOGS_NO_SUPPORT=true"
        # most hosts will be using the local nftables with the chain-built
        # firewall rules. tell tailscale that we are using nftables
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      # oneshot tailscale authentication service
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

          # check if we are already authenticated to Tailscale
          status="$(${tailscale.package}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"

          # if so, then do nothing
          if [ $status = "Running" ]; then
            exit 0
          fi

          # otherwise authenticate with tailscale
          ${tailscale.package}/bin/tailscale up ${toString tailscale.extraUpFlags}
        '';
      };
    };
  };
}
