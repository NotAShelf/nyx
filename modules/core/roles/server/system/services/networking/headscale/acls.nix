{pkgs, ...}: {
  services.headscale.settings.acl_policy_path = pkgs.writeTextFile {
    name = "headscale-acl.hujson";
    text = builtins.toJSON {
      acls = [
        {
          action = "accept";
          src = ["*"];
          dst = ["*:*"];
        }
      ];

      ssh = [
        {
          action = "accept";
          src = ["enyo"];
          dst = ["*"];
          users = ["notashelf"];
        }
      ];
      autoApprovers = {
        exitNode = ["*"];
      };
    };
  };
}
