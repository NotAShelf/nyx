{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) length zipListsWith;
  inherit (lib.strings) concatStringsSep escapeShellArg;
in {
  # This is set by `programs.nh.flake` by itself. We're just setting it here
  # so that we have a FLAKE variable set even when nh is disabled.
  environment.variables.FLAKE = "/home/notashelf/.config/nyx";

  programs.nh = {
    enable = true;
    package = pkgs.nh;

    # path to the system flake
    flake = "/home/notashelf/.config/nyx";

    # whether to let nh run gc on the store weekly
    clean = {
      enable = false; # nix-auto-gc is enabled on all systems, nh isn't.
      dates = "weekly";
    };
  };

  # Normally we wouldn't use overlays, because we wouldn't need the tree-wide
  # butterfly effect of changing a derivation permanently. However, we *want*
  # nom to be chaanged permanently across the tree so that the UI is consistent
  # with the rest of the system.
  nixpkgs.overlays = [
    (_: prev: let
      oldIcons = [
        "↑"
        "↓"
        "⏱"
        "⏵"
        "✔"
        "⏸"
        "⚠"
        "∅"
        "∑"
      ];
      newIcons = [
        "f062" # 
        "f063" # 
        "f520" # 
        "f04b" # 
        "f00c" # 
        "f04c" # 
        "f071" # 
        "f1da" # 
        "f04a0" # 󰒠
      ];
    in {
      # Create an overlay for nix-output-monitor to match the inconsistent
      # and frankly ugly icons with Nerdfonts ones. they look a little larger
      # than before, but overall consistency is better in general.
      nix-output-monitor = assert length oldIcons == length newIcons;
        prev.nix-output-monitor.overrideAttrs (old: {
          version = "0-unstable-2024-06-22";
          patches =
            (old.patches or [])
            ++ [
              (pkgs.fetchpatch {
                url = "https://github.com/maralorn/nix-output-monitor/commit/738f445082d6d5c8f96701ccd1fe1136a7a47715.patch";
                hash = "sha256-6uq55PmenrrqVx+TWCP2AFlxlZsYu4NXRTTKYIwRdY4=";
              })
            ];

          postPatch =
            (old.postPatch or "")
            + ''
              sed -i ${escapeShellArg (
                concatStringsSep "\n" (zipListsWith (a: b: "s/${a}/\\\\x${b}/") oldIcons newIcons)
              )} lib/NOM/Print.hs

              substituteInPlace lib/NOM/Print/Tree.hs --replace-fail '┌' '╭'
            '';
        });
    })
  ];
}
