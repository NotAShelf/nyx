{config, ...}: {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];

      log-lines = 30;
      warn-dirty = false;
      http-connections = 50;
      accept-flake-config = true;
      auto-optimise-store = true;

      flake-registry = "";
      nixPath = ["nixpkgs=${config.nix.registry.nixpkgs.to.path}"];
    };
  };
}
