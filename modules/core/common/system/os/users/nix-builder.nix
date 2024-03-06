{
  users = {
    groups.nix = {};

    users.nix-builder = {
      useDefaultShell = true;
      isSystemUser = true;
      createHome = true;
      group = "nix";
      home = "/var/tmp/nix-builder";
      openssh.authorizedKeys = {
        keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3Oglg7aVYQJzGa4JhnvDhRYx0jkLHwDT/9IyiLUNS2 notashelf@enyo"];
        # keyFiles = []; # TODO: can this be used with agenix?
      };
    };
  };
}
