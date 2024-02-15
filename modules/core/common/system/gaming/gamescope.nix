{pkgs, ...}: {
  config = {
    security.wrappers = {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${pkgs.gamescope}/bin/gamescope";
        capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
      };
    };

    programs.gamescope.enable = true;
  };
}
