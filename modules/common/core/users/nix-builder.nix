_: {
  users.users.nix-builder = {
    isSystemUser = true;
    description = "Nix Remote Build";
    home = "/var/tmp/nix-builder";
    createHome = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK3Oglg7aVYQJzGa4JhnvDhRYx0jkLHwDT/9IyiLUNS2"
    ];
    group = "nix";
  };
  users.groups.nix = {};
}
