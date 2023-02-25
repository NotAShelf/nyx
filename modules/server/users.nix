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

  /*
  users.users.donut = {
    group = "users";
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYvciy1uq5tU179OgChwrgbrGia4tUQr1onik5GuHc6 amr@nicksos"
    ];
  };
  */

  users.users.raf = {
    group = "users";
    extraGroups = ["gitea"];
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "changeme";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCJfqq5YP9CqOt3xQTzsEl8rJWRncA7UABHciggHdMBTSK6KYmp1GOnlAQOCHxHuuMn/6RgJ+V5Pbt53mjoc3BzfL256K3inx1t/cu90VpGrKS2k6JyMVUZL445VjVevJcMrQWK3ssHoqBHVj1fWZ+IYheiUGEfFAJZcd7feKjQHu5WpqlA8mFHiqWgjy3FwuXeLIDwvYYJezRq25y7T9hQLSDlkoH+IUoaiE0Zy2Rl4O/eFwU8jypebu1uJv5qiM6AQxTf2+/lqOLSyM5wP3xNAEjQ3Zs+9tqtAkoLxPP4KxwSJIcMA2UXAhDbhvljmxAPC270kZxv1mz3eq18RkDN3wTuQXudiU4X4J7WhZHXWC78lfPGR2Bqrpru06G5zpn/YjwgC7H2frArdqDQ1vxTBKaIB18X6GjfLVxLvSeoWvIrAOUMiI29pqmSTf7Dns61zp70l6FDmPLXVmWSFFCi6R4lMtq0CioXl/OaP1gFX3BlJ8jnyf1Sm++GnQMBis= notashelf@prometheus"
    ];
  };
}
