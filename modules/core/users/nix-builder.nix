_: {
  users.users.nix-builder = {
    isSystemUser = true;
    description = "Nix Remote Build";
    home = "/var/tmp/nix-remote-builder";
    createHome = true;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHPfiul8S+vHtq5BGsCk2yO+moH2FjFOcUou99nuNbPg63tc2l2eq6vZbOvCuBHRpYNIpiLrKWlrUMawBm3N0ECX7ZXfUX5+7YI+nn+/JTuL1qTcfL6jYMV2ZD067M+tzyogBd+vU6YE977oHnh3PimcuOB+GqDce1BzBMJeBv5e+wiwSRy6B5/QgKPnxg1vMhylq5PlpvkZes1Rj0Tgv3ZKC4umccSq+zZ44D7HdlUKKTJTnMlXEAkB2MOTLlZeXoDf8vdxSlK2GqxnZTObATVbZ8xLXswhAY2ZEL3sbB+tv0VPNCAdgCEYFveVuj0OoC054WmW3xzO8EP1mx3wfNdxsMPMvOP/eiaPWxOPoRVHeu2rVPbr5XDO2DF2RcbLUUS0b6fBmR/MaRFvvjicjAgkUXscbH6FtUnSY4jn6kaLA48NBoMQ4YIWvsmWxKNOSo71Vg+2OaQvWMoGRqh/IWm35Z9+3umDhp1CdnV+cJlzFsFOR/WX/UmBNmXdfdaXU="
    ];
    group = "nix-builder";
  };
  users.groups.nix = {};
}
