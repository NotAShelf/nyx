{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  # This defines the custom library and its functions. What happens below is that we extend `nixpkgs.lib` with
  # my own set of functions, designed to be used within this repository.
  # You will come to realize that this is an ugly solution. The lib directory and the contents of this file
  # are frustratingly convoluted, and lib.extend cannot handle merging parent attributes (e.g self.modules
  # and super.modules will override each other, and not merge) so we cannot use the same names as nixpkgs.
  # This is a problem, as I want to use the same names as nixpkgs, but with my own functions. However there
  # is no clear solution to this problem, so we make all custom functions available under
  #  1. self.extendedLib, which is a set containing all custom parent attributes
  #  2. self.lib, which is the extended library.
  # There are technically no limitations to this approach, but if you want to avoid using shorthand aliases
  # to provided function, you would need to do something like `lib.extendedLib.aliases.foo` instead of
  # `lib.aliases.foo`, which is kinda annoying.
  extendedLib = lib.extend (self: super: let
    inherit (self.trivial) functionArgs;
    inherit (self.attrsets) filterAttrs mapAttrs recursiveUpdate;

    # the below function is by far the most cursed I've put in my configuration
    # if you are, for whatever reason, copying my configuration - PLEASE omit this
    # and do your imports manually
    # credits go to @nrabulinski
    callLibs = path: let
      func = import path;
      args = functionArgs func;
      requiredArgs = filterAttrs (_: val: !val) args;
      defaultArgs = recursiveUpdate (mapAttrs (_: _: null) requiredArgs) {
        inherit inputs;
        lib = self;
      };
      functor = {__functor = _: attrs: func (recursiveUpdate defaultArgs attrs);};
    in
      (func defaultArgs) // functor;
  in {
    extendedLib = {
      # Aliases, or rather, templates containing commonly used strings or sets
      # across multiple parts of the configuration. One example for this is the nginx
      # SSL template, which is used practically for every service that faces
      # the internet.
      aliases = callLibs ./aliases.nix;

      # System builders and similar functions. Generally, those are abstractions around functions
      # found in nixpkgs, such as nixosSystem or evalModules, that simplify host creation.
      builders = callLibs ./builders.nix;

      # Helpers for converting data formats to and from other formats. This is a
      # very broad category, so anything could go here in theory.
      conversions = callLibs ./conversions.nix;

      # Utilities for working with GitHub or/and Forgejo workflows. So far, it
      # is an adaptation of nix-github-actions to suit my needs.
      ci = callLibs ./ci.nix;

      # DAG library is a modified version of the one found in
      # rycee's NUR repository
      dag = callLibs ./dag.nix;

      # Helpers for working with the firewall, which is currently nftables. The
      # below library contains helpers for building nftables chains and tables
      # from nix attribute sets.
      firewall = callLibs ./firewall.nix {inherit (self.extendedLib) dag;};

      # Functions for working with filesystems. In its current state, fs library
      # contains only a single function, which is mkBtrfs, a helper for creating
      # a btrfs filesystem with my preferred options.
      fs = callLibs ./fs.nix;

      # Checks and assertions for validating hardware capabilities of any given
      # host. Generally wraps around pkgs.stdenv.hostPlatform, but with additional
      # checks for validating host architecture and so on.
      hardware = callLibs ./hardware.nix;

      # An assortment of miscellaneous functions
      # that don't fit anywhere else.
      misc = callLibs ./misc.nix;

      # Module builders and utilities for the custom module structure found in this
      # repository.
      modules = callLibs ./modules.nix;

      # Functions for working with systemd sockets and their namespacing features.
      # This is kinda WIP, and is not used anywhere yet. Could be omitted if desired.
      namespacing = callLibs ./namespacing.nix;

      # Utilities for working with system secrets
      secrets = callLibs ./secrets.nix;

      # Functions for working with systemd services. Includes an utility for passing
      # common hardening options, or creating services with well known targets, such
      # as graphical-session.target
      systemd = callLibs ./systemd.nix;

      # Various assertions for verifying system features.
      validators = callLibs ./validators.nix;

      # Utilities for working with styling options, i.e., themes
      themes = callLibs ./themes.nix;

      # XDG user directories and templates.
      # xdg = callLibs ./xdg.nix;
    };

    # A shorthand alias for the xdg templates used by nixos and home-manager.
    # This is certainly a weird approach, but I do not know how to handle this
    # in a better way.
    xdgTemplate = ./xdg.nix;

    # Get individual functions from the parent attributes
    inherit (self.extendedLib.aliases) sslTemplate common;
    inherit (self.extendedLib.builders) mkSystem mkNixosSystem mkNixosIso mkSDImage mkRaspi4Image;
    inherit (self.extendedLib.dag) entryBefore entryBetween entryAfter entryAnywhere topoSort dagOf;
    inherit (self.extendedLib.firewall) mkTable mkRuleset mkIngressChain mkPrerouteChain mkInputChain mkForwardChain mkOutputChain mkPostrouteChain;
    inherit (self.extendedLib.fs) mkBtrfs;
    inherit (self.extendedLib.hardware) isx86Linux primaryMonitor;
    inherit (self.extendedLib.misc) filterNixFiles importNixFiles boolToNum fetchKeys containsStrings indexOf intListToStringList;
    inherit (self.extendedLib.modules) mkService mkModuleTree mkModuleTree';
    inherit (self.extendedLib.namespacing) makeSocketNsPhysical makeServiceNsPhysical unRestrictNamespaces;
    inherit (self.extendedLib.secrets) mkAgenixSecret;
    inherit (self.extendedLib.systemd) hardenService mkGraphicalService mkHyprlandService;
    inherit (self.extendedLib.themes) serializeTheme compileSCSS;
    inherit (self.extendedLib.validators) ifTheyExist ifGroupsExist isAcceptedDevice isWayland ifOneEnabled;
  });
in {
  perSystem = {
    # Set the `lib` arg of the flake as the extended lib. If I am right, this should
    # override the previous argument (i.e. the original nixpkgs.lib, provided by flake-parts
    # as a reasonable default) with my own, which is the same nixpkgs library, but actually extended
    # with my own custom functions.
    imports = [{_module.args.lib = extendedLib;}];
  };

  flake = {
    # Also set `lib` as a flake output, which allows for it to be referenced outside
    # the scope of this flake. This is useful for when I want to refer to my extended
    # library from outside this flake, or if someone wants to access my functions
    # but that rarely happens, Ctrl+C and Ctrl+V is the developer way it seems.
    lib = extendedLib;
  };
}
