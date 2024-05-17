{
  pkgs,
  lib,
  ...
}: let
  mkAcl = action: src: dst: {inherit action src dst;};
  mkSshAcl = action: src: dst: users: {inherit action src dst users;};
in {
  services.headscale.settings.acl_policy_path = pkgs.writeTextFile {
    name = "headscale-acl.hujson";
    text = builtins.toJSON {
      acls = [
        (mkAcl "accept" ["tag:client"] ["tag:client:*"]) # client <-> client
        (mkAcl "accept" ["tag:client"] ["tag:server:*"]) # client -> server
      ];

      ssh = [
        (mkSshAcl "accept" ["tag:client"] ["tag:server" "tag:client"] ["notashelf"]) # client -> client; client -> server
      ];

      tagOwners = let
        users = ["notashelf"];
        tags = map (name: "tag:${name}") ["server" "client"];
      in
        lib.genAttrs tags (_: users);

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
