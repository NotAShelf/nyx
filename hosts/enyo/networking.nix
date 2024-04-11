{
  #  we don't want the kernel setting up interfaces magically for us
  boot.extraModprobeConfig = "options bonding max_bonds=0";
  networking = {
    useDHCP = false;
    useNetworkd = false;
  };

  systemd.network = {
    enable = true;

    wait-online = {
      enable = false;
      anyInterface = true;
      extraArgs = ["--ipv4"];
    };

    # https://wiki.archlinux.org/title/Systemd-networkd
    networks = {
      # leave the kernel dummy devies unmanagaed
      "10-dummy" = {
        matchConfig.Name = "dummy*";
        networkConfig = {};
        # linkConfig.ActivationPolicy = "always-down";
        linkConfig.Unmanaged = "yes";
      };

      # let me configure tailscale manually
      "20-tailscale-ignore" = {
        matchConfig.Name = "tailscale*";
        linkConfig = {
          Unmanaged = "yes";
          RequiredForOnline = false;
        };
      };

      # wired interfaces e.g. ethernet
      "30-network-defaults-wired" = {
        # matchConfig.Name = "en* | eth* | usb*";
        matchConfig.Type = "ether";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          IPForward = "yes";
          IPMasquerade = "no";
        };

        dhcpV4Config = {
          ClientIdentifier = "duid"; # "mac"
          Use6RD = "yes";
          RouteMetric = 512; # should be higher than the wireless RouteMetric so that wireless is preferred
          UseDNS = false;
          DUIDType = "link-layer";
        };

        dhcpV6Config = {
          RouteMetric = 512;
          PrefixDelegationHint = "::64";
          UseDNS = false;
          DUIDType = "link-layer";
        };
      };

      # wireless interfaces e.g. network cards
      "30-network-defaults-wireless" = {
        # matchConfig.Name = "wl*";
        matchConfig.Type = "wlan";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = true;
          IPForward = "yes";
          IPMasquerade = "no";
        };

        dhcpV4Config = {
          ClientIdentifier = "mac";
          RouteMetric = 216;
          UseDNS = true;
          DUIDType = "link-layer";
          Use6RD = "yes";
        };

        dhcpV6Config = {
          RouteMetric = 216;
          UseDNS = true;
          DUIDType = "link-layer";
          PrefixDelegationHint = "::64";
        };
      };
    };
  };
}
