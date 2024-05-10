{pkgs, ...}: {
  users.users.yubikey = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
