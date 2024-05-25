{keys, ...}: {
  users = {
    groups.builder = {};
    users.builder = {
      useDefaultShell = true;
      isSystemUser = true;
      createHome = true;
      group = "builder";
      home = "/var/tmp/builder";
      openssh.authorizedKeys = {
        keys = [keys.notashelf];
      };
    };
  };
}
