{
  lib,
  inputs,
  pkgs,
  ...
}:
with {inherit (lib.util.map) array;}; {
  imports = [./index.nix inputs.utils.nixosModules.autoGenFromInputs];

  ## Nix Settings ##
  config = {
    # Utilities
    user.persist.dirs = [".cache/nix" ".cache/manix"];
    environment.systemPackages = [pkgs.cachix] ++ array (import ./format.nix) pkgs;

    # Settings
    nix = {
      # Version
      package = pkgs.nix;

      # Garbage Collection
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      # User Permissions
      allowedUsers = ["root" "@wheel"];
      trustedUsers = ["root" "@wheel"];

      # Registry
      linkInputs = true;
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;

      # Additional Features
      useSandbox = true;
      systemFeatures = ["kvm" "recursive-nix"];
      extraOptions = ''
        accept-flake-config = true
        warn-dirty = false
        experimental-features = nix-command flakes recursive-nix
        min-free = ${toString (1024 * 1024 * 1024)}
        max-free = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };
  };
}