{
  keys,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkForce mkMerge;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) elemAt;
  inherit (lib) mkPubkeyFor;
in {
  services = {
    openssh = {
      # enable openssh
      enable = true;
      openFirewall = true; # the ssh port(s) should be automatically passed to the firewall's allowedTCPports
      ports = [30]; # the port(s) openssh daemon should listen on
      startWhenNeeded = true; # automatically start the ssh daemon when it's required
      settings = {
        # no root login
        PermitRootLogin = mkForce "no";

        # no password auth
        # force publickey authentication only
        PasswordAuthentication = false;
        AuthenticationMethods = "publickey";
        PubkeyAuthentication = "yes";
        ChallengeResponseAuthentication = "no";
        UsePAM = false;

        # remove sockets as they get stale
        # this will unbind gnupg sockets if they exists
        StreamLocalBindUnlink = "yes";

        KbdInteractiveAuthentication = mkDefault false;
        UseDns = false; # no
        X11Forwarding = false; # ew xorg

        # key exchange algorithms recommended by `nixpkgs#ssh-audit`
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
          "diffie-hellman-group-exchange-sha256"
          "sntrup761x25519-sha512@openssh.com"
        ];

        # message authentication code algorithms recommended by `nixpkgs#ssh-audit`
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];

        # kick out inactive sessions
        ClientAliveCountMax = 5;
        ClientAliveInterval = 60;

        # max auth attempts
        MaxAuthTries = 3;
      };

      hostKeys = mkDefault [
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
    fail2ban.jails = {
      # sshd jail
      sshd = {
        settings = {
          enabled = true;
          filter = "sshd[mode=aggressive]";
          port = concatStringsSep "," (map toString config.services.openssh.ports);
        };
      };
    };
  };

  # Add my SSH keys to initrd for remote unlocking. Backdoor?!
  boot.initrd.network.ssh.authorizedKeys = [keys.notashelf];
  programs.ssh = let
    # a list of hosts that are connected over Tailscale
    # it would be better to construct this list dynamically
    # but we hardcode it because we cannot check if a host is
    # authenticated - that needs manual intervention
    hosts = ["helios" "enyo" "hermes"];

    # generate the ssh config for the hosts
    mkHostConfig = hostname: ''
      # Configuration for ${hostname}
      Host ${hostname}
       HostName ${hostname}
      Port ${toString (elemAt config.services.openssh.ports 0)}
       StrictHostKeyChecking=accept-new
    '';

    hostConfig = concatStringsSep "\n" (map mkHostConfig hosts);
  in {
    startAgent = !config.modules.system.yubikeySupport.enable;
    extraConfig = ''
      ${hostConfig}
    '';

    # Vendor hardcoded GitHub/GitLab/Sourcehut/Openwrt keys to avoid MitM (man in the middle) attacks.
    knownHosts = mkMerge [
      (mkPubkeyFor "github.com" "ssh-rsa" "AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=")
      (mkPubkeyFor "github.com" "ecdsa-sha2-nistp256" "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=")
      (mkPubkeyFor "github.com" "ssh-ed25519" "AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl")
      (mkPubkeyFor "gitlab.com" "ssh-rsa" "AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9")
      (mkPubkeyFor "gitlab.com" "ecdsa-sha2-nistp256" "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=")
      (mkPubkeyFor "gitlab.com" "ssh-ed25519" "AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf")
      (mkPubkeyFor "git.openwrt.org" "ssh-rsa" "AAAAB3NzaC1yc2EAAAABIwAAAQEAtnM1w/A1uRZqZuYHhw4ASOe9mr3J2qKAa9K9zR8jG+B+NQVtYlIBSkmCFyP6OuydCmoRZ5Gs1I9pl/hEyi7ieEi6g9yww/JbV322cw04Tli46enIYDG1bnSxF6Qt4aXqvPhcObI3z/1Z3XR6weS1fiLDzLvzq+w1gNM77xExD4Mh27LTPkdwOWjkGa5joNx3EQUC3rzwxUqE4fhOT2Ii93h8FSAUXY9C32jkJj9x7vfaJEsCacs6YTiUKKxyzEB+TvFZdUtGtoRThX7UVICUCD2th/r3UeSp8ItWPg/KqzSg2pRfWeYszlVoD59JZ6YCupSjjRqZddghQc94Hev7oQ==")
      (mkPubkeyFor "git.openwrt.org" "ecdsa-sha2-nistp256" "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBASOHg+tghASiZF0ClxYb/HEhUcqnD43I86YatRZSUsXNWLEd8yOzjOJExDHHaKtmZtQ/jfEMmoYbCjdEDOYm5g=")
      (mkPubkeyFor "git.openwrt.org" "ssh-ed25519" "AAAAC3NzaC1lZDI1NTE5AAAAIJZFpKQMaLM8bG9lAPfEpTBExrzuiTKMni7PgktmDbJe")
      (mkPubkeyFor "git.sr.ht" "ssh-rsa" "AAAAB3NzaC1yc2EAAAADAQABAAABAQDZ+l/lvYmaeOAPeijHL8d4794Am0MOvmXPyvHTtrqvgmvCJB8pen/qkQX2S1fgl9VkMGSNxbp7NF7HmKgs5ajTGV9mB5A5zq+161lcp5+f1qmn3Dp1MWKp/AzejWXKW+dwPBd3kkudDBA1fa3uK6g1gK5nLw3qcuv/V4emX9zv3P2ZNlq9XRvBxGY2KzaCyCXVkL48RVTTJJnYbVdRuq8/jQkDRA8lHvGvKI+jqnljmZi2aIrK9OGT2gkCtfyTw2GvNDV6aZ0bEza7nDLU/I+xmByAOO79R1Uk4EYCvSc1WXDZqhiuO2sZRmVxa0pQSBDn1DB3rpvqPYW+UvKB3SOz")
      (mkPubkeyFor "git.sr.ht" "ecdsa-sha2-nistp256" "AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCj6y+cJlqK3BHZRLZuM+KP2zGPrh4H66DacfliU1E2DHAd1GGwF4g1jwu3L8gOZUTIvUptqWTkmglpYhFp4Iy4=")
      (mkPubkeyFor "git.sr.ht" "ssh-ed25519" "AAAAC3NzaC1lZDI1NTE5AAAAIMZvRd4EtM7R+IHVMWmDkVU3VLQTSwQDSAvW0t2Tkj60")
    ];
  };
}
