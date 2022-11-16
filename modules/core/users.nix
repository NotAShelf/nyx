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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEv2abP11prPhH45NjKKqyldtnFpPFiagLFOslvPsYvjJPD1rLL/LsmBQYbRlcPi8uvQksGsY3KJE3MDIMc8d8uFmn5E12HoNbWy/jZanbQWA+6FADUf6D+tTlzcHM+iIRRGQpZLrh796BVabMgkduV2e3FiqUNsAqfZNEWL3ryUSI265lZkobn24wx2Sxn8rSVtQcsWbVkmmbGxcZ2sZpPb4dUNvm9Kb14kllLw13PxgxNyPuq77bCuSGuBRNYJASQIT++ePL2eUc43OgciB3MOkt9hMkcI6BHpPSg7lvCbl/Xv18Lw2tx9ohi+TfYL1p1DH3Yi3ZJMEQ/XUdsuWv0eJ84Mysg1OMb4FdLe1Uc0LdGF65tl54cbAqKl7u5ic1tILDk9q97Akhb0PV4q9wm+av8qczVwfElnCIIKfYFPRBqKFFe6hv5rYhU8xqKPHalEBMTtEw0jMbyigmJGPaKi+pRPu2R94BTIKqUc/ciJhUqGrzPX2ugGv5ZvfUPM0= notashelf@pavillion"
      # TODO: add desktop pubkey here
    ];
  };
}
