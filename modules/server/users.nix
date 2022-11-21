{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.git = {
    isSystemUser = true;
    extraGroups = [];
    useDefaultShell = true;
    home = "/var/lib/gitea";
    group = "gitea";
  };

  users.users.donut = {
    group = "users";
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYvciy1uq5tU179OgChwrgbrGia4tUQr1onik5GuHc6 amr@nicksos"
    ];
  };

  users.users.raf = {
    group = "users";
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      ""
    ];
  };
}
