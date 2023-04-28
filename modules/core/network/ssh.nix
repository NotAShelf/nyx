{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      permitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
      kbdInteractiveAuthentication = lib.mkDefault false;
      useDns = false;
      X11Forwarding = false;
    };

    # the ssh port(s) should be automatically passed to the firewall's allowedTCPports
    openFirewall = true;
    ports = [30];

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
