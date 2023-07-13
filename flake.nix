{
  description = "My NixOS configuration with *very* questionable stability";
  # https://github.com/notashelf/nyx

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      systems = [
        # systems for which you want to build the `perSystem` attributes
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
        ./parts/pkgs # packages exposed by the flake
        ./parts/args # args that is passsed to the flake, moved away from the main file
      ];

      flake = let
        # extended nixpkgs library, contains my custom functions
        # such as system builders
        lib = import ./lib {inherit nixpkgs lib inputs;};
      in {
        # TODO
        darwinConfigurations = {};

        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts {inherit nixpkgs self lib withSystem;};

        # set of modules exposed by my flake to be consumed by others
        # you can import these by adding my flake to your inputs and then importing the module you prefer
        # i.e imports = [ inputs.nyx.nixosModules.steam-compat ];
        nixosModules = {
          # extends the steam module from nixpkgs/nixos to add a STEAM_COMPAT_TOOLS option
          steam-compat = ./modules/extra/shared/nixos/steam;

          # a module for the comma tool that wraps it with nix-index and disabled the command-not-found integration
          comma-rewrapped = ./modules/extra/shared/nixos/comma;

          # a git-like service I packaged for no apparent reason
          onedev = ./modules/extra/export/onedev;

          # we do not want to provide a default module
          default = null;
        };

        homeManagerModules = {
          xplr = ./modules/extra/shared/home-manager/xplr;

          # against we do not want to provide a default module
          default = null;
        };

        # developer templates for easy project initialization
        # TODO: rewrite templates for my go-to languages
        # templates = import ./lib/flake/templates;

        # TODO: flake checks to be invoked by nix flake check
        # checks = import ./lib/flake/checks;

        # Recovery images for my hosts
        # build with `nix build .#images.<hostname>`
        images = import ./hosts/images.nix {inherit inputs self lib;};
      };

      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: {
        imports = [{_module.args.pkgs = config.legacyPackages;}];

        devShells.default = let
          devShell = import ./parts/devShell;
        in
          inputs'.devshell.legacyPackages.mkShell {
            name = "nyx";
            commands = devShell.shellCommands;
            env = devShell.env;
            packages = with pkgs; [
              inputs'.agenix.packages.default # provide agenix CLI within flake shell
              config.treefmt.build.wrapper # treewide formatter
              nil # nix ls
              alejandra # nix formatter
              git # flakes require git, and so do I
              glow # markdown viewer
              statix # lints and suggestions
              deadnix # clean up unused nix code
            ];
          };

        # provide the formatter for nix fmt
        formatter = pkgs.alejandra;

        # configure treefmt
        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = false;
            shellcheck.enable = true;
            stylua.enable = true;
            rustfmt.enable = true;
            shfmt = {
              enable = true;
              # https://flake.parts/options/treefmt-nix.html#opt-perSystem.treefmt.programs.shfmt.indent_size
              # 0 causes shfmt to use tabs
              indent_size = 0;
            };
          };
        };
      };
    });

  inputs = {
    # powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # build against nixos unstable, more variants can be added if deemed necessary
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Automated, pre-built packages for Wayland
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Repo for hardare-specific NixOS modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix helper
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # a tree-wide formatter
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # An upstream, feature-rich fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";

    # project shells
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Easy color integration
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix gaming packages
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management via agenix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Language server
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    # my personal neovim-flake
    neovim-flake = {
      url = "github:NotAShelf/neovim-flake?ref=release/v0.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my own arrpc-flake to provide arRPC package
    arrpc = {
      url = "github:NotAShelf/arrpc-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # use my own wallpapers repository to provide various wallpapers as nix packages
    wallpkgs = {
      url = "github:NotAShelf/wallpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:SoraTenshi/helix/new-daily-driver";
      inputs = {
        rust-overlay.follows = "rust-overlay";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # anyrun program launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
    };

    # spicetify for theming spotify
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland & Hyprland Contrib repos
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xdg-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence
    impermanence.url = "github:nix-community/impermanence";

    # secure-boot on nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mailserver on nixos
    simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
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
