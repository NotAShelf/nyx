{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  nix = {
    package = pkgs.nixVersions.latest;
    channel.enable = false; # locks us out of lookup paths such as <nixpkgs>
    nixPath = ["nixpkgs=${config.nix.registry.nixpkgs.to.path}"];

    settings = {
      # Enable flakes. This is mandatory to install this configuration.
      experimental-features = ["nix-command" "flakes"];

      log-lines = 50;
      warn-dirty = false;
      http-connections = 50;
      accept-flake-config = false;
      auto-optimise-store = false;

      # Never run out of disk space. Though the installer is generally
      # designed to be in-memory only, so is this necessary?
      max-free = mkDefault (3000 * 1024 * 1024);
      min-free = mkDefault (512 * 1024 * 1024);

      # Disable built-in registry
      flake-registry = "";

      # Fallback quickly if substituters are not available.
      connect-timeout = 5;

      # Make building installed systems faster
      substituters = [
        "https://cache.nixos.org"
        "https://cache.privatevoid.net"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://anyrun.cachix.org"
        "https://nyx.cachix.org"
        "https://neovim-flake.cachix.org"
        "https://cache.notashelf.dev"
        "https://ags.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
        "neovim-flake.cachix.org-1:iyQ6lHFhnB5UkVpxhQqLJbneWBTzM8LBYOFPLNH4qZw="
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
      ];
    };
  };
}
