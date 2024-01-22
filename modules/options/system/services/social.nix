{lib, ...}: let
  inherit (lib) mkModule;
in {
  options.modules.system.services = {
    # self-hosted/decentralized social networks
    social = {
      mastodon = mkModule {
        name = "Mastodon";
        type = "social";
      };
      matrix = mkModule {
        name = "Matrix";
        type = "social";
        port = 8008;
      };
    };
  };
}
