{lib, ...}:
with lib; let
  device = config.modules.device;
  acceptedTypes = ["server" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    services = {
      # redis setup for nitter
      redis = {
        servers = {
          "nitter" = {
            enable = true;
            port = 6379;
          };
        };
      };

      nitter = {
        # TODO: caching and redis setup
        enable = true;
        openFirewall = true;
      };
    };
  };
}
