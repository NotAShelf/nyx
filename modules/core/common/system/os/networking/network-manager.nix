{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf mkForce;

  dev = config.modules.device;
  sys = config.modules.system;

  inherit (sys.networking) wireless;
in {
  # we use networkmanager manage network devices locally
  environment.systemPackages = with pkgs; [networkmanagerapplet];
  networking = {
    networkmanager = {
      enable = true;
      plugins = mkForce []; # disable all plugins, we don't need them
      dns = "systemd-resolved"; # use systemd-resolved as dns backend
      unmanaged = [
        "interface-name:tailscale*"
        "interface-name:br-*"
        "interface-name:rndis*"
        "interface-name:docker*"
        "interface-name:virbr*"
        "interface-name:vboxnet*"
        "interface-name:waydroid*"
        "type:bridge"
      ];

      wifi = {
        inherit (wireless) backend; # this can be iwd or wpa_supplicant, use wpa_supp. until iwd support is stable
        macAddress = "random"; # use a random mac address on every boot
        powersave = true; # enable wifi powersaving
        scanRandMacAddress = true; # MAC address randomization of a Wi-Fi device during scanning
      };

      ethernet.macAddress = mkIf (dev.type != "server") "random"; # causes server to be unreachable over SSH
    };

    # enable IPV6 support
    enableIPv6 = true;
  };
}
