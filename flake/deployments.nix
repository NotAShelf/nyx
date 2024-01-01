{
  inputs,
  self,
  lib,
  ...
}: let
  includedNodes = ["enyo" "helios"];
  mkNode = name: cfg: let
    inherit (cfg.pkgs.stdenv.hostPlatform) system;
    deployLib = inputs.deploy-rs.lib.${system};
  in {
    # this looks pretty goofy, I should get a simpler domain
    # it's actually hostname.namespace.domain.tld but my domain and namespace are the same
    hostname = "${name}.notashelf.notashelf.dev";
    sshOpts = ["-p" "30"];
    skipChecks = true;
    # currently only a single profile system
    profilesOrder = ["system"];
    profiles.system = {
      sshUser = "root";
      user = "root";
      path = deployLib.activate.nixos cfg;
    };
  };
  nodes = lib.mapAttrs mkNode (lib.filterAttrs (name: _: lib.elem name includedNodes) self.nixosConfigurations);
in {
  flake = {
    deploy = {
      autoRollback = true;
      magicRollback = true;
      inherit nodes;
    };
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: let
    deployPkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.deploy-rs.overlay
        (_: prev: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            inherit (prev.deploy-rs) lib;
          };
        })
      ];
    };
  in {
    # evaluation of deployChecks is slow
    # checks = (deployPkgs.deploy-rs.lib.deployChecks self.deploy)

    apps.deploy = {
      type = "app";
      program = pkgs.writeShellScriptBin "deploy" ''
        ${deployPkgs.deploy-rs.deploy-rs}/bin/deploy --skip-checks
      '';
    };
  };
}
