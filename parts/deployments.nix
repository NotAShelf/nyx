{
  self,
  lib,
  ...
}: let
  inherit (lib) mkNode;
  inherit (lib.lists) elem;
  inherit (lib.attrsets) mapAttrs filterAttrs;

  includedNodes = ["enyo" "helios"];
  finalNodes = mapAttrs mkNode (filterAttrs (name: _: elem name includedNodes) self.nixosConfigurations);
in {
  flake.deploy = {
    autoRollback = true;
    magicRollback = true;
    nodes = finalNodes;
  };

  perSystem = {
    inputs',
    system,
    pkgs,
    ...
  }: {
    # evaluation of deployChecks is slow
    # checks = mapAttrs (_: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    apps.deploy = {
      type = "app";
      program = pkgs.writeShellScriptBin "deploy" ''
        local system=$1;

        echo "Deploying to $system...";
        ${inputs'.deploy-rs.packages.deploy-rs}/bin/deploy --skip-checks $system
      '';
    };
  };
}
