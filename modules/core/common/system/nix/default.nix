{
  inputs,
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.trivial) pipe;
  inherit (lib.types) isType;
  inherit (lib.attrsets) mapAttrsToList optionalAttrs filterAttrs mapAttrs;
  inherit (lib.modules) mkDefault;
in {
  imports = [
    ./transcend # module that merges trees outside central nixpkgs with our system's
    ./builders.nix # import builders config
    ./overlays.nix
  ];

  system = {
    autoUpgrade.enable = false;
    stateVersion = mkDefault "23.05";
  };

  environment = {
    etc = with inputs; {
      # set channels (backwards compatibility)
      "nix/flake-channels/system".source = self;
      "nix/flake-channels/nixpkgs".source = nixpkgs;
      "nix/flake-channels/home-manager".source = home-manager;

      # preserve current flake in /etc
      "nixos/flake".source = self;
    };

    # we need git for flakes, don't we
    systemPackages = [pkgs.git];
  };

  nixpkgs = {
    # https://github.com/NixOS/nixpkgs/commit/eb8ce7930d14dafcc7eff56c2f9efca6a3b2f622
    # pkgs = self.legacyPackages.${config.nixpkgs.system};

    config = {
      allowUnfree = true; # really a pain in the ass to deal with when disabled
      allowBroken = false;
      allowUnsupportedSystem = true;

      # default to none, add more as necessary
      permittedInsecurePackages = [
        "electron-24.8.6"
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];
    };
  };

  # faster rebuilding
  documentation = {
    doc.enable = false;
    nixos.enable = true;
    info.enable = false;
    man = {
      enable = mkDefault true;
      generateCaches = mkDefault true;
    };
  };

  nix = let
    # mappedRegistry = mapAttrs (_: v: {flake = v;}) inputs;
    mappedRegistry = pipe inputs [
      (filterAttrs (_: isType "flake"))
      (mapAttrs (_: flake: {inherit flake;}))
      (x: x // {nixpkgs.flake = inputs.nixpkgs;})
    ];
  in {
    package = pkgs.nixSuper; # pkgs.nixVersions.unstable;

    # pin the registry to avoid downloading and evaluating a new nixpkgs version every time
    # this will add each flake input as a registry to make nix3 commands consistent with your flake
    # additionally we also set `registry.default`, which was added by nix-super
    registry = mappedRegistry // optionalAttrs (config.nix.package == pkgs.nixSuper) {default = mappedRegistry.nixpkgs;};

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # make builds run with low priority so my system stays responsive
    # this is especially helpful if you have auto-upgrade on
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # set up garbage collection to run weekly,
    # removing unused packages that are older than 7 days
    gc = {
      automatic = true;
      dates = "Mon *-*-* 03:00";
      options = "--delete-older-than 7d";
    };

    # automatically optimize nix store my removing hard links
    # do it after the gc
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };

    settings = {
      # tell nix to use the xdg spec for base directories
      # while transitioning, any state must be carried over
      # manually, as Nix won't do it for us
      use-xdg-base-directories = true;

      # specify the path to the nix registry
      flake-registry = "/etc/nix/registry.json";

      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # automatically optimise symlinks
      auto-optimise-store = true;

      # allow sudo users to mark the following values as trusted
      allowed-users = ["root" "@wheel" "nix-builder"];

      # only allow sudo users to manage the nix store
      trusted-users = ["root" "@wheel" "nix-builder"];

      # let the system decide the number of max jobs
      max-jobs = "auto";

      # build inside sandboxed environments
      sandbox = true;
      sandbox-fallback = false;

      # supported system features
      system-features = ["nixos-test" "kvm" "recursive-nix" "big-parallel"];

      # extra architectures supported by my builders
      extra-platforms = config.boot.binfmt.emulatedSystems;

      # continue building derivations if one fails
      keep-going = true;

      # show more log lines for failed builds
      log-lines = 30;

      # enable new nix command and flakes
      # and also "unintended" recursion as well as content addresssed nix
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "recursive-nix" # let nix invoke itself
        "ca-derivations" # content addressed nix
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "configurable-impure-env" # allow impure environments
        "cgroups" # allow nix to execute builds inside cgroups
        "git-hashing" # allow store objects which are hashed via Git's hashing algorithm
        "verified-fetches" # enable verification of git commit signatures for fetchGit
      ];

      # don't warn me that my git tree is dirty, I know
      warn-dirty = false;

      # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
      http-connections = 50;

      # whether to accept nix configuration from a flake without prompting
      accept-flake-config = false;

      # execute builds inside cgroups
      use-cgroups = true;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # use binary cache, this is not gentoo
      # external builders can also pick up those substituters
      builders-use-substitutes = true;

      # substituters to use
      substituters = [
        "https://cache.ngi0.nixos.org" # content addressed nix cache (TODO)
        "https://cache.nixos.org" # funny binary cache
        "https://cache.privatevoid.net" # for nix-super
        "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
        "https://nix-community.cachix.org" # nix-community cache
        "https://hyprland.cachix.org" # hyprland
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://numtide.cachix.org" # another unfree package cache
        "https://anyrun.cachix.org" # anyrun program launcher
        "https://nyx.cachix.org" # cached stuff from my flake outputs
        "https://neovim-flake.cachix.org" # a cache for my neovim flake
        "https://cache.garnix.io" # garnix binary cache, hosts prismlauncher
        "https://cache.notashelf.dev" # my own binary cache, served over https
        "https://ags.cachix.org" # ags
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
        "neovim-flake.cachix.org-1:iyQ6lHFhnB5UkVpxhQqLJbneWBTzM8LBYOFPLNH4qZw="
        "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.notashelf.dev-1:DhlmJBtURj+XS3j4F8SFFukT8dYgSjtFcd3egH8rE6U="
        "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
      ];
    };
  };
}
