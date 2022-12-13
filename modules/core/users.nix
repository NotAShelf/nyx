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
      "plugdev"
      "lp"
      "networkmanager"
      "libvirtd"
      "tss"
      "power"
      "nix"
    ];
    uid = 1000;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpSqOPiFLyE4X+7CoV2b7iAmqsV1vsfiwyKd4Vmz8oVEaiRGBL9m6WYDMn/MwUF+cFsQ9RixfvpV1p0SyO05aNMHcO38efPkar6WLtYid0WoMdalWuC2RJh2ZB3AJXbY2JsDOiGM6r7iR/ZsFZyARaCnGLTHqZqKv6zZBl2snxsiZyXfsqmWNMlh8lTkTkK59ktBz+/c7AC9vx8eiCG/nBZFR0lXKNFODRgt2iYBkWdCTpAAaZa1S3QgbuxdhxefMtyrCTbUpunPuMixoO5TB8L0rvz2J3HuqkkjQ5vHJuHe5BIY+PbT3wJifWR7fILpLl28CbfMIivuSPt/WI7kk1q8x5UonRTEeEIALDmN46jg2Hibn6k1fyWH6U8thsH6zLNrpNL0lpiQM2nqs0hbEFht/D8JghdXHgWtfI/BbOTnl6XEbnZpvlJzdy0IkfmIn3VCjXQ7LocMC0PxsGzi6E4fhUAZ9gueY+gXgLrWP6e14SeceyizZPfqTaIuky498= notashelf@notapc"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzp/3hogooArvQN+UMwzPA9CXY+Ch7x8eBRjMYR1A9/UDHIPEa/Pcwgat/v2Ciscejbg+3Hpy2L1KHpUKIzIXRw3vySGzFBT4tYBI8/85fw/pTvH+o9gm1jsODCDQprCtbQoX09ZxZQYmMh94UJehPNM3ZHP6qS98EfJvv3plg/JG7cYIag65UPJ6gfcwCKo3ZDIx9szbV3YzsnQFhgnIyK822s9lBQ9C0UDumUiGJeOP35cOVf9ZsLhNhP8Zv4E6F3DzxlCon/ysHF3bzK9bq8yFJgJCeQtTnEBFcQAE7oYh/m5CrMGXcKpILAWESVAw/FdAr5bS08+7+8xp+brgTWWiKMPRWlwS+FL0DfHYp0ftXJFPH6eWu7gdCSLrlSl/ZktWHr5nOgFFHUQBYWo+4W1Kj/vlT9OxqEcnGkoj5raCCDF9RHG6RXjH27e5vjFk0pBQP3IvUIeRzcw1miMiQYBwSzA6CXZwVLaTvfjCywr+CjEgOfA3dMS+p38Ew8SE= notashelf@prometheus"
    ];
  };
}
