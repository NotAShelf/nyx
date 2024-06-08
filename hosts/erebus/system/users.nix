{pkgs, ...}: {
  users.users."notashelf" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
