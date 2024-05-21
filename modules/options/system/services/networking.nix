{lib, ...}: let
  inherit (lib) mkEnableOption mkService;
  inherit (lib.types) str;
in {
  options.modules.system.services = {
    # networking
    networking = {
      wireguard.enable = mkEnableOption "Wireguard service";
      headscale = mkService {
        name = "Headscale";
        type = "networking";
        port = 8085;
        /*
        extraOptions = {
          domain = mkOption {
            type = str;
            example = "headscale.example.com";
            description = "The domain name to use for headscale";
          };
        };
        */
      };
    };
  };
}
