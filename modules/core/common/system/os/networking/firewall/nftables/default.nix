{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkRuleset;

  sys = config.modules.system;
  cfg = config.networking.nftables;

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
  imports = [./rules.nix];
  config = mkIf sys.networking.nftables.enable {
    networking.nftables = {
      enable = true;

      # flush ruleset on each reload
      flushRuleset = true;

      # nftables.tables is semi-verbatim configuration
      # that is inserted **before** nftables.ruleset
      # as per the nftables module.
      tables = {
        "fail2ban" = {
          name = "fail2ban-nftables";
          family = "ip";
          content = ''
            # <https://wiki.gbe0.com/en/linux/firewalling-and-filtering/nftables/fail2ban>
            chain input {
              type filter hook input priority 100;
            }
          '';
        };
      };

      # our ruleset, built with our local ruleset builder from lib/network/firewall.nix
      # I prefer using this to the nftables.tables.* and verbatim nftables.ruleset = ""
      # kinds of configs, as it allows me to programmatically approach to my ruleset
      # instead of structuring it inside a multiline string. nftables.rules, which is
      # located in ./rules.nix, is easily parsable and modifiable with the help of Nix.
      ruleset = mkRuleset cfg.rules;
    };

    assertions = [
      {
        assertion = import "${check-results}/assertion";
        message = ''
          Bad config:
          ${builtins.readFile "${check-results}/message"}
        '';
      }
    ];

    # pin IFD as a system dependency
    # this makes sure the IFD result is realised in time
    # without making the IFD a part of the system
    # unlike system.extraDependencies
    system.checks = [check-results];
  };
}
