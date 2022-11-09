{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # disable the docs, it sucks anyway
  documentation.enable = false;

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];

    settings = {
      experimental-features = "recursive-nix nix-command flakes";
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      allowed-users = [
        "root"
        "@wheel"
      ];
      # use binary cache, its not gentoo
      substituters = [
        "https://cache.nixos.org"
        "https://fortuneteller2k.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];

      sandbox = true;
      system-features = ["kvm" "recursive-nix"];
      #extraOptions = ''
      #  accept-flake-config = true
      #  warn-dirty = false
      #  experimental-features = nix-command flakes recursive-nix
      #  min-free = ${toString (1024 * 1024 * 1024)}
      #  max-free = ${toString (10 * 1024 * 1024 * 1024)}
      #'';
    };
    extraOptions = ''
      accept-flake-config = true
      warn-dirty = false
    '';
  };
}
