# Headscale on NixOS, Tailscale anywhere

Today's main attraction is the Headscale setup on my VPS running NixOS, which
I've finally came around to self-host.

There has been much talk about this new product called Tailscale recently around
the web, especially in the last few years. Tailscale is a VPN service that makes
the devices and applications we own accessible anywhere using the open source
WireGuard protocol to establish encrypted point-to-point connections. I have
been using Tailscale for a while now, but in an effort to move all of my
services to self-owned hardware some of my services have been moved over to my
NixOS server over time.

Many of Tailscale’s components are open-source, especially its clients, but the
server remains closed-source. Tailscale is a SaaS product and monetization
naturally is a big concern, however, we care more about controlling our own data
than their attempts of monetization.

This is where the (very appropriately named) Headscale comes in; Headscale is an
open-source, self-hosted implementation of the Tailscale control server. The
configuration is extremely straightforward, as Headscale will handle everything
for us.

## Running Headscale

Below is a simple configuration for the Headscale module of NixOS.

```nix
services = let
  domain = "example.com";
in {
  headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 8085;

    settings = {
      server_url = "https://tailscale.${domain}";

      dns_config = {
        override_local_dns = true;
        base_domain = "${domain}";
        magic_dns = true;
        domains = ["tailscale.${domain}"];
        nameservers = [
          "9.9.9.9" # no cloudflare, nice
        ];
      };

      ip_prefixes = [
        "100.64.0.0/10"
        "fd7a:115c:a1e0::/48"
      ];
    };
  };
};
```

## Using Headscale

We must first create a user, which we can do with

```console
headscale users create myUser
```

Then on the machine that will be our client, we need to login.

```console
tailscale up --login-server tailscale.example.com # replace this URL with your own as configured abovea
```

Followed by registering the machine.

```console
# machine key will be obtained visiting the URL that is returned from the above command
headscale --user myUser nodes register --key <MACHINE_KEY>
```

And finally logging into your Tailnet using the URL and your machine key.

```console
tailscale up --login-server https://tailscale.example.com --authkey <YOUR_AUTH_KEY>
```

And all done! Now try connecting to one of your machines using the hostname now
to test if the connection is actually working. If anything goes wrong, make sure
to check your DNS settings: remember, it's always the DNS.
