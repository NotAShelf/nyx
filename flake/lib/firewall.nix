{
  lib,
  dag,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) optionalString concatMapStringsSep concatStringsSep;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.lists) concatLists;
  inherit (lib) types;
  inherit (dag) dagOf topoSort;

  mkTable = desc: body:
    mkOption {
      default = {};
      description = "Containers for chains, sets, and other stateful objects.";
      type = types.submodule ({config, ...}: {
        options =
          {
            enable = mkEnableOption desc;
            objects = mkOption {
              type = with types; listOf str;
              description = "Objects associated with this table.";
              default = [];
            };
          }
          // body;

        config = let
          buildChainDag = chain:
            concatMapStringsSep "\n" ({
              name,
              data,
            }: let
              protocol =
                if builtins.isNull data.protocol
                then ""
                else data.protocol;
              field =
                if builtins.isNull data.field
                then ""
                else data.field;
              inherit (data) policy;
              values = map toString data.value;
              value =
                if builtins.isNull data.value
                then ""
                else
                  (
                    if builtins.length data.value == 1
                    then builtins.head values
                    else "{ ${concatStringsSep ", " values} }"
                  );
            in ''
              ${protocol} ${field} ${value} ${policy} comment ${name}
            '') ((topoSort chain).result or (throw "Cycle in DAG"));

          buildChain = chainType: chain:
            mapAttrsToList (chainName: chainDag: ''
              chain ${chainName} {
                type ${chainType} hook ${chainName} priority 0;

                ${buildChainDag chainDag}
              }
            '') (filterAttrs (_: g: builtins.length (builtins.attrNames g) > 0) chain);
        in {
          objects = let
            chains = concatLists [
              (
                if config ? filter
                then buildChain "filter" config.filter
                else []
              )
              (
                if config ? nat
                then buildChain "nat" config.nat
                else []
              )
              (
                if config ? route
                then buildChain "route" config.route
                else []
              )
            ];
          in
            chains;
        };
      });
    };

  mkChain = _: description:
    mkOption {
      inherit description;
      default = {};
      type = dagOf (types.submodule {
        options = {
          protocol = mkOption {
            default = null;
            description = "Protocol to match.";
            type = with types;
              nullOr (either (enum [
                  "ether"
                  "vlan"
                  "arp"
                  "ip"
                  "icmp"
                  "igmp"
                  "ip6"
                  "icmpv6"
                  "tcp"
                  "udp"
                  "udplite"
                  "sctp"
                  "dccp"
                  "ah"
                  "esp"
                  "comp"
                ])
                str);
          };

          field = mkOption {
            default = null;
            description = "Field value to match.";
            type = with types;
              nullOr (enum [
                "dport"
                "sport"
                "daddr"
                "saddr"
                "type"
                "state"
                "iifname"
                "pkttype"
              ]);
          };

          value = mkOption {
            default = null;
            description = "Associated value.";
            type = with types; let
              valueType = oneOf [port str];
            in
              nullOr (coercedTo valueType (value: [value]) (listOf valueType));
          };

          policy = mkOption {
            description = "What to do with matching packets.";
            type = types.enum [
              "accept"
              "reject"
              "drop"
              "log"
            ];
          };
        };
      });
    };

  mkRuleset = ruleset:
    concatStringsSep "\n" (mapAttrsToList (name: table:
      optionalString (builtins.length table.objects > 0) ''
        table ${name} nixos {
          ${concatStringsSep "\n" table.objects}
        }
      '')
    ruleset);

  mkIngressChain = mkChain "Process all packets before they enter the system";
  mkPrerouteChain = mkChain "Process all packets entering the system";
  mkInputChain = mkChain "Process packets delivered to the local system";
  mkForwardChain = mkChain "Process packets forwarded to a different host";
  mkOutputChain = mkChain "Process packets sent by local processes";
  mkPostrouteChain = mkChain "Process all packets leaving the system";
in {
  inherit mkTable mkRuleset mkIngressChain mkPrerouteChain mkInputChain mkForwardChain mkOutputChain mkPostrouteChain;
}
