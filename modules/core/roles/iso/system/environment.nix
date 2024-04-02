{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  environment = {
    # our installer is a minimal, TUI-only environment. I don't find any
    # good reason to keep X11 libs around while we will not be depending
    # on any GUI frameworks.
    noXlibs = true;

    # 24.04 has brought in a stub-ld that will throw a warning if you try to run a
    # dynamically linked binary. This is an installer, so we probably won't try to run
    # dynamically linked binaries on this system. Besides, it's annoying.
    stub-ld.enable = mkForce false;

    # NixOS bundles a few packages by default
    # it's not too large of a list, but I don't need it and I prefer
    # my system containing only the packages I've declared.
    defaultPackages = mkForce [];

    # packages I might want on an installer environment
    systemPackages = with pkgs; [
      gitMinimal
      curl
      wget
      pciutils
      lshw
      rsync
      nixos-install-tools
    ];

    etc = {
      # link a copy of our nixpkgs input as the nixpkgs channel
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;

      # fix an annoying warning
      "mdadm.conf".text = ''
        MAILADDR root
      '';
    };
  };
}
