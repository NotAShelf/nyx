{
  config,
  pkgs,
  lib,
  ...
}: {
  # Propetheus Exporter
  services = {
    prometheus.exporters.node = {
      enable = true;
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
      openFirewall = true;
      firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
    };
    openssh = {
      enable = true;
      permitRootLogin = lib.mkForce "no";
      openFirewall = true;
      forwardX11 = false;
      ports = [22];
      passwordAuthentication = lib.mkForce false;
      hostKeys = [];
    };
    fail2ban = {
      enable = true;
      maxretry = 5;
      ignoreIP = [
        "127.0.0.0/8"
        "10.0.0.0/8"
      ];
    };
    # Nextcloud WIP
  };
}
