{
  config,
  pkgs,
  ...
}: {
  users.users.notashelf = {
    createHome = true;
    isNormalUser = true;
    group = "users";
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
    uid = 1001;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8PoV2sELn2vm+LxdHq056t47dtD6d/phS7KPzjkwpufb+/z9U2l9ZJPMm3VpkTi/YUBYbsaoSuEp034GeP2L4sbeRziMX/Pu5YoZJsFRs4xjHLdmc/IAjRtlyCE1WO0upoKDQyhmj6izSSqncVNu54Vc8LUfm9qtaxsITNtgPKdkOVcAraxCMUtPCVmYnS3UWuHrW8R7kevNny0bNxn8DiOaE5N8x9OoV+plJbKl1lSEFtpgSIKinOtiLnUnU76ubeQB/QXZbt+rqw06j14dyVlUnEH2D+bEmOw3q+JfEixdF8SfUbxhhY0foeqJtWKz/3hxT9Wf/xP27PIhidducN8e8gRKwUS5NFPtb2Je6Q82K3dGTgF1zQvGsTcy7/QFwDLnKu38QTRo7CL6K1llZHA5A9YVMZAgEWGBrgKMMf2wAPTil45Gddpl+YumkhMTgXmmG/1oHocfTO2hjGN3pGleKOxmPnEFgKJBMBQMy0Ayqbou+USmWf5hZlgb1bs0= notashelf@prometheus"
      # TODO: add desktop pubkey here
    ];
  };
}
