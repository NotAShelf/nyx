{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = lib.mkForce "no";
      PasswordAuthentication = false;
      kbdInteractiveAuthentication = lib.mkDefault false;
      useDns = false;
      X11Forwarding = false;
    };

    openFirewall = true;
    ports = [22];

    hostKeys = [
      {
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}
