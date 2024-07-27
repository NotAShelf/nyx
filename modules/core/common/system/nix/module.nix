{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (self) inputs;
  inherit (builtins) elem;
  inherit (lib.trivial) pipe;
  inherit (lib.types) isType;
  inherit (lib.attrsets) mapAttrsToList filterAttrs mapAttrs mapAttrs';
in {
  imports = [
    ./overlays # tree-wide overrides for packages and such
    ./transcend # module that merges trees outside central nixpkgs with our system's

    ./builders.nix # configuration for remote builders
    ./documentation.nix # nixos documentation
    ./nixpkgs.nix # global nixpkgs configuration.nix
    ./system.nix # nixos system configuration
  ];

  # Link selected flake inputs to `/etc/nix/path` for added backwards compatibility.
  # Some of them, as long as they are made compatible with flakes, can be used with
  # nix's discouraged special lookup paths (e.g. <nixpkgs>) if you really need them
  # to. Should be noted, however, that special lookup paths are discouraged and the
  # only real reason they are here is backwards compatibility, and sometimes my own
  # convenience. If you are using a flake, you should be using the flake's outputs.
  environment.etc = let
    inherit (config.nix) registry;
    commonPaths = ["home-manager" "nixpkgs" "nyxexprs"];
  in
    pipe registry [
      (filterAttrs (name: _: (elem name commonPaths)))
      (mapAttrs' (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      }))
    ];

  nix = let
    mappedRegistry = pipe inputs [
      (filterAttrs (_: isType "flake"))
      (mapAttrs (_: flake: {inherit flake;}))
      (flakes: flakes // {nixpkgs.flake = inputs.nixpkgs;})
    ];
  in {
    # Lix, the higher performance Nix fork.
    package = pkgs.lix;

    # Pin the registry to avoid downloading and evaluating
    # a new nixpkgs version on each command causing a re-eval.
    # This will add each flake input as a registry and make
    # nix3 commands consistent with your flake.
    registry = mappedRegistry // {default-flake = mappedRegistry.nixpkgs;};

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # Run the Nix daemon on lowest possible priority so that my system
    # stays responsive during demanding tasks such as GC and builds.
    # This is especially useful while auto-gc and auto-upgrade are enabled
    # as they can be quite demanding on the CPU.
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;

    # Collect garbage
    gc = {
      automatic = true;
      dates = "Sat *-*-* 03:00";
      options = "--delete-older-than 30d";
      persistent = false; # don't try to catch up on missed GC runs
    };

    # Automatically optimize nix store my removing hard links
    # do it after the gc.
    optimise = {
      automatic = true;
      dates = ["04:00"];
    };

    settings = {
      # Tell nix to use the xdg spec for base directories
      # while transitioning, any state must be carried over
      # manually, as Nix won't do it for us.
      use-xdg-base-directories = true;

      # Allow usage of registry lookups (e.g. flake:*) but
      # disallow internal flake registry by setting it to
      # to a minimal JSON file with no flakes and a version
      # identifier.
      use-registries = true;
      flake-registry = pkgs.writeText "flakes-empty.json" (builtins.toJSON {
        flakes = [];
        version = 2;
      });

      # Free up to 10GiB whenever there is less than 5GB left.
      # this setting is in bytes, so we multiply with 1024 thrice
      min-free = "${toString (5 * 1024 * 1024 * 1024)}";
      max-free = "${toString (10 * 1024 * 1024 * 1024)}";

      # Automatically optimise symlinks
      auto-optimise-store = true;

      # Allow sudo users to mark the following values as trusted
      allowed-users = ["root" "@wheel" "nix-builder"];

      # Only allow sudo users to manage the nix store
      trusted-users = ["root" "@wheel" "nix-builder"];

      # Let the system decide the number of max jobs
      # based on available system specs. Usually this is
      # the same as the number of cores your CPU has.
      max-jobs = "auto";

      # Always build inside sandboxed environments
      sandbox = true;
      sandbox-fallback = false;

      # Supported system features
      system-features = ["nixos-test" "kvm" "recursive-nix" "big-parallel"];

      # Extra architectures supported by my builders. Default list is
      # picked from systems emulated by binfmt.
      extra-platforms = config.boot.binfmt.emulatedSystems;

      # Continue building derivations even if one fails
      keep-going = true;

      # Fallback to local builds after remote builders are unavailable.
      # Setting this too low on a slow network may cause remote builders
      # to be discarded before a connection can be established.
      connect-timeout = 5;

      # If we haven't received data for >= 20s, retry the download
      stalled-download-timeout = 20;

      # Show more logs when a build fails and decides to display
      # a bunch of lines. `nix log` would normally provide more
      # information, but this may save us some time and keystrokes.
      log-lines = 30;

      # Extra features of Nix that are considered unstable
      # and experimental. By default we should always include
      # `flakes` and `nix-command`, while others are usually
      # optional.
      extra-experimental-features = [
        "flakes" # flakes
        "nix-command" # experimental nix commands
        "recursive-nix" # let nix invoke itself
        "ca-derivations" # content addressed nix
        "auto-allocate-uids" # allow nix to automatically pick UIDs, rather than creating nixbld* user accounts
        "cgroups" # allow nix to execute builds inside cgroups
        "repl-flake" # allow passing installables to nix repl
        "no-url-literals" # disallow deprecated url-literals, i.e., URLs without quotation
        "dynamic-derivations" # allow "text hashing" derivation outputs, so we can build .drv files.

        # Those don't actually exist on Lix so they have to be disabled
        # configurable-impure-env" # allow impure environments
        # "git-hashing" # allow store objects which are hashed via Git's hashing algorithm
        # "verified-fetches" # enable verification of git commit signatures for fetchGit
      ];

      # Ensures that the result of Nix expressions is fully determined by
      # explicitly declared inputs, and not influenced by external state.
      # In other words, fully stateless evaluation by Nix at all times.
      pure-eval = false; # pain

      # Don't warn me that my git tree is dirty, I know.
      warn-dirty = false;

      # Maximum number of parallel TCP connections
      # used to fetch imports and binary caches.
      # 0 means no limit, default is 25.
      http-connections = 35; # lower values fare better on slow connections

      # Whether to accept nix configuration from a flake
      # without displaying a Y/N prompt. For those obtuse
      # enough to keep this true, I wish the best of luck.
      # tl;dr: this is a security vulnerability.
      accept-flake-config = false;

      # Whether to execute builds inside cgroups. cgroups are
      # "a Linux kernel feature that limits, accounts for, and
      # isolates the resource usage (CPU, memory, disk I/O, etc.)
      # of a collection of processes."
      # See:
      # <https://en.wikipedia.org/wiki/Cgroups>
      use-cgroups = pkgs.stdenv.isLinux; # only supported on Linux

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # Use binary cache, this is not Gentoo
      # external builders can also pick up those substituters
      builders-use-substitutes = true;

      # Substituters to pull from. While sigs are disabled, we must
      # make sure the substituters listed here are trusted.
      substituters = [
        "https://cache.nixos.org" # funny binary cache
        "https://cache.privatevoid.net" # for nix-super
        "https://nix-community.cachix.org" # nix-community cache
        "https://hyprland.cachix.org" # hyprland
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://anyrun.cachix.org" # anyrun program launcher
        "https://nyx.cachix.org" # cached stuff from my flake outputs
        "https://neovim-flake.cachix.org" # a cache for my neovim flake
        "https://cache.garnix.io" # garnix binary cache, hosts prismlauncher
        "https://cache.notashelf.dev" # my own binary cache, served over https
        "https://ags.cachix.org" # ags
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
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

  # By default nix-gc makes no effort to respect battery life by avoiding
  # GC runs on battery and fully commits a few cores to collecting garbage.
  # This will drain the battery faster than you can say "Nix, what the hell?"
  # and contribute heavily to you wanting to build a desktop (do that anyway.)
  # For those curious (such as myself) desktops are always seen as "AC powered"
  # so the service will not fail to fire if you are on a desktop system.
  systemd.services.nix-gc = {
    unitConfig.ConditionACPower = true;
  };
}
