{
  # https://github.com/notashelf/nyx
  description = "My NixOS configuration with *very* questionable stability";

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      # systems for which the `perSystem` attributes will be built
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        # and more if they can be supported ...
      ];

      imports = [
        # add self back to inputs, I depend on inputs.self at least once
        {config._module.args._inputs = inputs // {inherit (inputs) self;};}

        # parts and modules from inputs
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.treefmt-nix.flakeModule

        # parts of the flake
        ./flake/pkgs # packages exposed by the flake
        ./flake/templates # flake templates # TODO: bash and python
        ./flake/schemas # home-baked schemas for upcoming nix schemas
        ./flake/modules # nixos and home-manager modules provided by this flake
        ./flake/treefmt # treefmt configuration

        ./flake/args.nix # args that are passsed to the flake, moved away from the main file
        ./flake/pre-commit.nix # pre-commit hooks, performed before each commit inside the devshell
      ];

      flake = let
        # extended nixpkgs library, contains my custom functions
        # such as system builders
        lib = import ./lib {inherit nixpkgs inputs;};
      in {
        # TODO: I still don't have machine to test my darwin configs on - avoid pushing
        # darwinConfigurations = {};

        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts {inherit nixpkgs self lib withSystem;};

        # Recovery images for my hosts
        # build with `nix build .#images.<hostname>`
        # alternatively hosts can be built with `nix build .#nixosConfigurations.hostName.config.system.build.isoImage`
        images = import ./hosts/images.nix {inherit inputs self lib;};
      };

      perSystem = {
        inputs',
        config,
        pkgs,
        ...
      }: {
        imports = [{_module.args.pkgs = config.legacyPackages;}];

        # provide the formatter for nix fmt
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          name = "nyx";
          meta.description = "The default development shell for my NixOS configuration";

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';

          # tell direnv to shut up
          DIRENV_LOG_FORMAT = "";

          # packages available in the dev shell
          packages = with pkgs; [
            inputs'.agenix.packages.default # provide agenix CLI within flake shell
            config.treefmt.build.wrapper # treewide formatter
            nil # nix ls
            alejandra # nix formatter
            git # flakes require git, and so do I
            glow # markdown viewer
            statix # lints and suggestions
            deadnix # clean up unused nix code
            (pkgs.writeShellApplication {
              name = "update";
              text = ''
                ${pkgs.runtimeShell}
                nix flake update && git commit flake.lock -m "flake: bump inputs"
              '';
            })
          ];

          inputsFrom = [
            config.treefmt.build.devShell
          ];
        };
      };
    });

  inputs = {
    # until a new release is out and in nixpkgs:
    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # We build against nixos unstable, because stable takes way too long to get things into
    # more versions with or without pinned branches can be added if deemed necessary
    # stable? never heard of her
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Ever wanted nix error messages to be even more cryptic?
    # Try flake-utils today! (Devs I beg you please stop)
    flake-utils.url = "github:numtide/flake-utils";

    # this will work one day
    # (eelco please)
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    # doesn't build
    nixSchemas.url = "github:DeterminateSystems/nix/flake-schemas";

    # Feature-rich and convenient fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix wrapper for building and testing my system
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ld lets us run unpatched dynamic binaries without (much) hassle
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Project shells
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # guess what this does
    # come on, try
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # sandbox wrappers for programs
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # This exists, I guess
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Impermanence
    # doesn't offer much about properly used symlinks but it *is* convenient
    impermanence.url = "github:nix-community/impermanence";

    # secure-boot on nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # nix-index database
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # easy color integration
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix gaming packages
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # Personal package overlay
    nyxpkgs.url = "github:NotAShelf/nyxpkgs";

    # Personal neovim-flake
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nil.follows = "nil";
        flake-utils.follows = "flake-utils";
        flake-parts.follows = "flake-parts";
      };
    };

    # neovim nightly packages for nix
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # arrpc-flake to provide arRPC package and home-manager module
    arrpc = {
      url = "github:NotAShelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my own wallpapers repository to provide various wallpapers as nix packages
    wallpkgs = {
      url = "github:NotAShelf/wallpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # anyrun program launcher
    anyrun.url = "github:Kirottu/anyrun";

    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs = {
        flake-parts.follows = "flake-parts";
      };
    };

    # spicetify for theming spotify
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
    nix flake for the prism launcher, provides more up-to-date packages than nixpkgs
    the inputs section below is to avoid cluttering system with more inputs than necessary
    which prismlauncher has a heck ton of
    https://github.com/PrismLauncher/PrismLauncher/blob/develop/flake.nix#L4
    */
    prism-launcher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pre-commit-hooks.follows = "pre-commit-hooks";
        flake-compat.follows = "flake-compat";
      };
    };

    # schizophrenic firefox configuration
    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nixpak.follows = "nixpak";
      };
    };

    # mailserver on nixos
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";

    # Hyprland & Hyprland Contrib repos
    hyprland.url = "github:hyprwm/Hyprland";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpaper.url = "github:hyprwm/hyprpaper";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://helix.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
      "https://notashelf.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
      "notashelf.cachix.org-1:VTTBFNQWbfyLuRzgm2I7AWSDJdqAa11ytLXHBhrprZk="
    ];
  };
}
