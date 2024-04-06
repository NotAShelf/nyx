{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce mkDefault;
in {
  imports = [
    ./firewall

    ./blocker.nix
    ./network-manager.nix
    ./optimize.nix
    ./resolved.nix
    ./ssh.nix
    ./tailscale.nix
    ./tcpcrypt.nix
    ./wireless.nix
  ];

  # network tools that are helpful and nice to have
  boot.kernelModules = ["af_packet"];
  environment.systemPackages = with pkgs; [
    mtr
    tcpdump
    traceroute
  ];

  networking = {
    # generate a unique hostname by hashing the hostname
    # with md5 and taking the first 8 characters of the hash
    # this is especially helpful while using zfs but still
    # ensures that there will be a unique hostId even when
    # we are not using zfs
    hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

    # global dhcp has been deprecated upstream
    # use the new networkd service instead of the legacy
    # "script-based" network setups. Host may contain individual
    # dhcp interfaces or systemd-networkd configurations in host
    # specific directories
    useDHCP = mkForce false;
    useNetworkd = mkForce true;

    # interfaces are assigned names that contain topology information (e.g. wlp3s0)
    # and thus should be consistent across reboots
    # this already defaults to true, we set it in case it changes upstream
    usePredictableInterfaceNames = mkDefault true;

    # dns
    nameservers = [
      # cloudflare, yuck
      # shares data
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"

      # quad9, said to be the best
      # shares *less* data
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # search paths used when resolving domain names
    # this can allow us to find hosts on private networks
    # e.g. wireguard, tailscale and headscale
    search = [
      "notashelf.dev" # referss to the server itself
      "notashelf.notashelf.dev" # headscale network
    ];
  };

  # enable wireless database, it helps with finding the right channels
  hardware.wirelessRegulatoryDatabase = true;

  # allow for the system to boot without waiting for the network interfaces are online
  # speeds up boot times
  systemd = let
    # TODO: allow for the hosts to define those interfaces
    ethernetDevices = [
      "wlp1s0f0u8" # wifi dongle
    ];
  in {
    # according to 23.11 release notes, wait-online target has long been fixed
    # spoiler: no it's not.
    network.wait-online.enable = false;
    services =
      {
        NetworkManager-wait-online.enable = false;

        # disable networkd and resolved from being restarted on configuration changes
        # lets me avoid a short network outage when I change the configuration
        # also means that I **must** reboot to make sure my network changes are
        # are properly propagated
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
