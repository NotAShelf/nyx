{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
with lib; {
  imports = [
    ./builders.nix # import builders config
  ];

  system = {
    autoUpgrade.enable = false;
    stateVersion = lib.mkDefault "23.05";
  };

  environment = {
    # set channels (backwards compatibility)
    etc = {
      #"nix/flake-channels/system".source = inputs.self; # no worky
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };

    # we need git for flakes, don't we
    systemPackages = [pkgs.git];
  };

  nixpkgs = {
    config = {
      allowUnfree = true; # really a pain in the ass to deal with when disabled
      allowBroken = true;
      allowUnsupportedSystem = true;
      permittedInsecurePackages = [
        "electron-21.4.0"
      ];
    };

    overlays = with inputs;
      [
        # TODO: hotswappable nur module in system-module
        # nur.overlay
        rust-overlay.overlays.default

        (self: super: {
          nixSuper = inputs.nix-super.packages.x86_64-linux.default;
        })
      ]
      # Overlays from the overlays directory
      ++ (lib.importNixFiles "${self}/pkgs/overlays");
  };

  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
  };

  nix = {
    package = pkgs.nixSuper; # pkgs.nixVersions.unstable;

    # Make builds run with low priority so my system stays responsive
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

    gc = {
      # set up garbage collection to run daily,
      # removing unused packages after three days
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    # pin the registry to avoid downloading and evalıationg a new nixpkgs
    # version everytime
    # this will add each flake input as a registry
    # to make nix3 commands consistent with your flake
    registry = mapAttrs (_: v: {flake = v;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
      accept-flake-config = true
      http-connections = 0
      warn-dirty = false
    '';

    settings = {
      auto-optimise-store = true;
      # allow sudo users to mark the following values as trusted
      allowed-users = ["@wheel"];
      # only allow sudo users to manage the nix store
      trusted-users = ["@wheel"];
      # let the system decide the number of max jobs
      max-jobs = "auto";
      # build inside sandboxed environments
      sandbox = true;
      # supported system features
      system-features = ["nixos-tests" "kvm" "recursive-nix" "big-parallel" "gccarch-core2" "gccarch-haswell"];
      # architectures supported by my builders
      extra-platforms = config.boot.binfmt.emulatedSystems;
      # continue building derivations if one fails
      keep-going = true;
      # show more log lines for failed builds
      log-lines = 20;
      # enable new nix command and flakes
      # and also "unintended" recursion as well as content addresssed nix
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # use binary cache, its not gentoo
      # this also allows us to use remote builders to reduce build times and batter usage
      builders-use-substitutes = true;
      # substituters to use
      substituters = [
        "https://cache.ngi0.nixos.org" # content addressed nix cache (TODO)
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
        "https://nix-community.cachix.org" # nix-community cache
        "https://hyprland.cachix.org" # hyprland
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://cache.privatevoid.net"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      ];
    };
  };
}
