{
  config,
  pkgs,
  ...
}: {
  users.users.notashelf = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "lp"
      "networkmanager"
      "systemd-journal"
      "video"
      "wheel"
      "wireshark"
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };
}
