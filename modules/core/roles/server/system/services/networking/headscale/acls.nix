{
  pkgs,
  lib,
  ...
}: let
  mkAcl = action: src: dst: {inherit action src dst;};
in {
  services.headscale.settings.acl_policy_path = pkgs.writeTextFile {
    name = "headscale-acl.hujson";
    text = builtins.toJSON {
      acls = [
        (mkAcl "accept" ["tag:client"] ["*:*"]) # client <-> client
        (mkAcl "accept" ["tag:client"] ["tag:server:*"]) # client -> server
      ];

      tagOwners = let
        me = ["notashelf"];
        tags = map (name: "tag:${name}") ["server" "client"];
      in
        lib.genAttrs tags (_: me);

      ssh = [
        {
          action = "accept";
          src = ["enyo"];
          dst = ["*"];
          users = ["notashelf"];
        }
      ];

      tags = [
        "tag:client"
        "tag:server"
      ];

      autoApprovers = {
        exitNode = ["*"];
      };
    };
  };
}
