{
  config,
  pkgs,
  ...
}: {
  users.users.notashelf = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "systemd-journal"
      "audio"
      "wireshark"
      "video"
      "input"
      "lp"
      "networkmanager"
      "libvirtd"
      "tss"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8PoV2sELn2vm+LxdHq056t47dtD6d/phS7KPzjkwpufb+/z9U2l9ZJPMm3VpkTi/YUBYbsaoSuEp034GeP2L4sbeRziMX/Pu5YoZJsFRs4xjHLdmc/IAjRtlyCE1WO0upoKDQyhmj6izSSqncVNu54Vc8LUfm9qtaxsITNtgPKdkOVcAraxCMUtPCVmYnS3UWuHrW8R7kevNny0bNxn8DiOaE5N8x9OoV+plJbKl1lSEFtpgSIKinOtiLnUnU76ubeQB/QXZbt+rqw06j14dyVlUnEH2D+bEmOw3q+JfEixdF8SfUbxhhY0foeqJtWKz/3hxT9Wf/xP27PIhidducN8e8gRKwUS5NFPtb2Je6Q82K3dGTgF1zQvGsTcy7/QFwDLnKu38QTRo7CL6K1llZHA5A9YVMZAgEWGBrgKMMf2wAPTil45Gddpl+YumkhMTgXmmG/1oHocfTO2hjGN3pGleKOxmPnEFgKJBMBQMy0Ayqbou+USmWf5hZlgb1bs0= notashelf@prometheus"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpSqOPiFLyE4X+7CoV2b7iAmqsV1vsfiwyKd4Vmz8oVEaiRGBL9m6WYDMn/MwUF+cFsQ9RixfvpV1p0SyO05aNMHcO38efPkar6WLtYid0WoMdalWuC2RJh2ZB3AJXbY2JsDOiGM6r7iR/ZsFZyARaCnGLTHqZqKv6zZBl2snxsiZyXfsqmWNMlh8lTkTkK59ktBz+/c7AC9vx8eiCG/nBZFR0lXKNFODRgt2iYBkWdCTpAAaZa1S3QgbuxdhxefMtyrCTbUpunPuMixoO5TB8L0rvz2J3HuqkkjQ5vHJuHe5BIY+PbT3wJifWR7fILpLl28CbfMIivuSPt/WI7kk1q8x5UonRTEeEIALDmN46jg2Hibn6k1fyWH6U8thsH6zLNrpNL0lpiQM2nqs0hbEFht/D8JghdXHgWtfI/BbOTnl6XEbnZpvlJzdy0IkfmIn3VCjXQ7LocMC0PxsGzi6E4fhUAZ9gueY+gXgLrWP6e14SeceyizZPfqTaIuky498= notashelf@notapc"
    ];
  };
}
