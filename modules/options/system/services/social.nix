{lib, ...}: let
  inherit (lib) mkService;
in {
  options.modules.system.services = {
    # self-hosted/decentralized social networks
    social = {
      mastodon = mkService {
        name = "Mastodon";
        type = "social";
      };
      matrix = mkService {
        name = "Matrix";
        type = "social";
        port = 8008;
      };
    };
  };
}
