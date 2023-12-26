{inputs}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl;
  inherit (import ./core.nix {inherit lib;}) import' mergeRecursively;

  # helpful utility functions used around the system
  builders = import' ./builders.nix {inherit inputs;}; # system builders
  services = import' ./services.nix; # systemd-service generators
  validators = import' ./validators.nix; # validate system conditions
  helpers = import' ./helpers; # helper functions
  hardware = import' ./hardware.nix; # hardware capability checks
  xdg = import' ./xdg; # xdg user directories & templates

  # abstractions over networking functions
  # dag library is a modified version of the one found in
  # rycee's NUR repository
  dag = import' ./network/dag.nix; # dag is in network because it's designed for network only use
  firewall = import' ./network/firewall.nix {inherit dag;}; # build nftables tables and chains
  namespacing = import' ./network/namespacing.nix; # TODO

  # aliases for commonly used strings or functions
  aliases = import' ./aliases.nix;

  importedLibs = [builders services validators helpers hardware aliases firewall namespacing dag xdg];
in
  # extend nixpkgs lib
  lib.extend (_: _: foldl mergeRecursively {} importedLibs)
