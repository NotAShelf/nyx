{
  lib,
  dag,
  ...
}: let
  inherit (builtins) length head;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.strings) optionalString concatMapStringsSep concatStringsSep;
  inherit (lib.attrsets) attrNames filterAttrs mapAttrsToList;
  inherit (lib.lists) concatLists;
  inherit (lib.types) nullOr enum either oneOf coercedTo listOf str submodule port;
  inherit (dag) dagOf topoSort;

  mkTable = desc: body:
    mkOption {
      default = {};
      description = "Containers for chains, sets, and other stateful objects.";
      type = submodule ({config, ...}: {
        options =
          {
            enable = mkEnableOption desc;
            objects = mkOption {
              type = listOf str;
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
                if data.protocol == null
                then ""
                else data.protocol;
              field =
                if data.field == null
                then ""
                else data.field;
              inherit (data) policy;
              values = map toString data.value;
              value =
                if data.value == null
                then ""
                else
                  (
                    if length data.value == 1
                    then head values
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
            '') (filterAttrs (_: g: length (attrNames g) > 0) chain);
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
      type = dagOf (submodule {
        options = {
          protocol = mkOption {
            default = null;
            description = "Protocol to match.";
            type = nullOr (either (enum [
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
            type = nullOr (enum [
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
            type = let
              valueType = oneOf [port str];
            in
              nullOr (coercedTo valueType (value: [value]) (listOf valueType));
          };

          policy = mkOption {
            description = "What to do with matching packets.";
            type = enum [
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
      optionalString (length table.objects > 0) ''
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
