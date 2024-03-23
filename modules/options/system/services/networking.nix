{lib, ...}: let
  inherit (lib) mkEnableOption mkModule;
  inherit (lib.types) str;
in {
  options.modules.system.services = {
    # networking
    networking = {
      wireguard.enable = mkEnableOption "Wireguard service";
      headscale = mkModule {
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
