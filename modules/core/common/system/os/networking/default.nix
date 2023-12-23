{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce mkDefault;

  dev = config.modules.device;
  sys = config.modules.system;
in {
  imports = [
    ./firewall

    ./ssh.nix
    ./blocker.nix
    ./tailscale.nix
    ./optimise.nix
    ./tcpcrypt.nix
  ];

  # network tools that are helpful and nice to have
  boot.kernelModules = ["af_packet"];
  environment.systemPackages = with pkgs; [
    mtr
    tcpdump
    traceroute
  ];

  services = {
    # systemd DNS resolver daemon
    resolved = {
      enable = true;
      # this is necessary to get tailscale picking up your headscale instance
      # and allows you to ping connected hosts by hostname
      domains = ["~."];
      # DNSSEC provides to DNS clients (resolvers) origin authentication of DNS data, authenticated denial of existence
      # and data integrity but not availability or confidentiality.
      # this is considered EXPERIMENTAL and UNSTABLE by upstream
      # PLEASE SEE <https://github.com/systemd/systemd/issues/25676#issuecomment-1634810897>
      # before you decide to set this
      # I have it set to false as the issue does not inspire confidence in system's ability to manage this
      dnssec = "false";
      # <https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS>
      # apparently upstream (systemd) recommends this to be false, `allow-downgrade` is vulnerable to downgrade attacks
      extraConfig = "DNSOverTLS=yes"; # or allow-downgrade
      # ideally our fallbackDns should be something more widely available
      # but I do not want my last resort to sell my data to every company available
      fallbackDns = ["9.9.9.9"];
    };
  };

  networking = {
    # generate a host ID by hashing the hostname
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # global dhcp has been deprecated upstream
    # use networkd instead
    # individual interfaces are still managed through dhcp in hardware configurations
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    # interfaces are assigned names that contain topology information (e.g. wlp3s0) and thus should be consistent across reboots
    # this already defaults to true, we set it in case it changes upstream
    usePredictableInterfaceNames = mkDefault true;

    # dns
    nameservers = [
      # cloudflare, yuck
      # shares data
      "1.1.1.1"
      "1.0.0.1"

      # quad9, said to be the best
      # shares *less* data
      "9.9.9.9"

      # TODO: find a schizo nameserver that does not compromise on speed or availability
      # or just set up my own, which would be slow
    ];

    wireless = {
      enable = sys.networking.wirelessBackend == "wpa_supplicant";
      userControlled.enable = true;
      iwd = {
        enable = sys.networking.wirelessBackend == "iwd";
        settings = {
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };

    # we use networkmanager manage network devices locally
    networkmanager = {
      enable = true;
      plugins = mkForce []; # disable all plugins, we don't need them
      dns = "systemd-resolved"; # use systemd-resolved as dns backend
      unmanaged = [
        "docker0"
        "rndis0"
        "interface-name:br-*"
        "interface-name:docker*"
        "interface-name:virbr*"
        "driver:wireguard" # don't manage wireguard, we want to do it outselves
      ];

      wifi = {
        backend = sys.networking.wirelessBackend; # this can be iwd or wpa_supplicant, use wpa_supp. until iwd support is stable
        macAddress = "random"; # use a random mac address on every boot
        powersave = true; # enable wifi powersaving
        scanRandMacAddress = true; # MAC address randomization of a Wi-Fi device during scanning
      };

      ethernet.macAddress = mkIf (dev.type != "server") "random"; # causes server to be unreachable over SSH
    };
  };

  # enable wireless database, it helps with finding the right channels
  hardware.wirelessRegulatoryDatabase = true;

  # allow for the system to boot without waiting for the network interfaces are online
  # speeds up boot times
  systemd = let
    ethernetDevices = [
      "wlp1s0f0u8" # wifi dongle
      "enp7s0" # ethernet interface on the motherboard
    ];
  in {
    # according to 23.11 release notes, wait-online target has been long fixed
    # spoiler, it's not.
    network.wait-online.enable = false;
    services =
      {
        NetworkManager-wait-online.enable = false;

        # disable networkd and resolved from being restarted on configuration changes
        systemd-networkd.stopIfChanged = false;
        systemd-resolved.stopIfChanged = false;
      }
      // lib.concatMapAttrs (_: v: v) (lib.genAttrs ethernetDevices (device: {
        # Assign an IP address when the device is plugged in rather than on startup. Needed to prevent
        # blocking the boot sequence when the device is unavailable, as it is hotpluggable.
        "network-addresses-${device}".wantedBy = lib.mkForce ["sys-subsystem-net-devices-${device}.device"];
      }));
  };
}
