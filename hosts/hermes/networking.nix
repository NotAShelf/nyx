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
          RouteMetric = 512;
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
          RouteMetric = 1500;
          UseDNS = true;
          DUIDType = "link-layer";
          Use6RD = "yes";
        };

        dhcpV6Config = {
          RouteMetric = 1500;
          UseDNS = true;
          DUIDType = "link-layer";
          # routes = [
          #   { routeConfig = { Gateway = "_dhcp4"; Metric = 1500; }; }
          #   { routeConfig = { Gateway = "_ipv6ra"; Metric = 1500; }; }
          # ];
          PrefixDelegationHint = "::64";
        };
      };
    };
  };
}
