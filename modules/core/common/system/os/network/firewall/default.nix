{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce;
  dev = config.modules.device;
  cfg = config.networking.nftables;
in {
  imports = [
    ./fail2ban.nix
    ./nftables.nix
  ];

  config = let
    check-results =
      pkgs.runCommand "check-nft-ruleset" {
        ruleset = pkgs.writeText "nft-ruleset" cfg.ruleset;
      } ''
        mkdir -p $out
        ${pkgs.nftables}/bin/nft -c -f $ruleset 2>&1 > $out/message \
          && echo false > $out/assertion \
          || echo true > $out/assertion
      '';
  in {
    services = {
      # enable opensnitch firewall
      # inactive until opensnitch UI is opened
      opensnitch.enable = true;
    };

    networking = {
      firewall = {
        enable = !cfg.enable;
        package =
          if cfg.enable
          then pkgs.iptables-nftables-compat
          else pkgs.iptables;
        allowedTCPPorts = [443 8080];
        allowedUDPPorts = [];
        allowPing = dev.type == "server";
        logReversePathDrops = true;
        logRefusedConnections = false; # avoid log spam
        checkReversePath = mkForce false; # Don't filter DHCP packets, according to nixops-libvirtd
      };
    };

    assertions = [
      {
        message = ''
          Bad config:
          ${builtins.readFile "${check-results}/message"}
        '';
        assertion = import "${check-results}/assertion";
      }
    ];

    system.extraDependencies = [check-results]; # pin IFD as a system dependency
  };
}
