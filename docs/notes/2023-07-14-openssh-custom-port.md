# Nix remote builders on non-standard OpenSSH ports

My VPS, which hosts some of my infrastructure, has been running NixOS for a
while now. Although weak, I use it for distributed builds alongside the rest of
my NixOS machines on a Tailscale network.

This server, due to it hosting my infrastructure that communicates with the rest
of the internet (i.e my mailserver), is somewhat responsive to queries from the
public - which includes _very_ aggressive portscans (thanks, skiddies!)

To mitigate that, I have decided to change the ssh port from the default **22**
to something different. While this is not exactly a pancea, it helps alleviate
the insane log spam I get from failed ssh requests.

## The OpenSSH Configuration

First thing we've done is to configure openssh to listen on the new port on your
server configuration

```nix
services.openssh = {
  ports = [2222];
}
```

With this set, openssh on the server will now be listening on the port **2222**
instead of the default **22**. For the changes to take effect after a rebuild,
you might need to run `systemctl restart sshd.socket`.

Then we want to configure our client to use the correct port for our server
instead of the default **22**.

```nix
programs.ssh.extraConfig = ''
    Host nix-builder
      HostName nix-builder-hostname # if you are using Tailscale, this can just be the hostname of a device on your Tailscale network
	  Port 2222
'';
```

And done, that is all for the ssh side of things. Next up, we need to configure
out builder to use the correct host.

## Nix Builder Configuration

Assuming you already have a remote builder configured, you will only need to
patch the `hostName` with the one on your `openssh.extraConfig`.

```nix
nix.buildMachines = [{
    hostName = "nix-builder-hostname";
    sshUser = "nix-builder";
    sshKey = "/path/to/key";
    systems = ["x86_64-linux"];
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = ["kvm"];
}];
```

If you have added the correct `hostName` and `sshUser`, the builder will be
picked up automatically on the next rebuild.

### Home-Manager

If you are using Home-Manager, you might also want to configure your declarative
~/.config/ssh/config to use the new port. That can be achieved through
`programs.ssh.matchBlocks` option under Home-Manager

```nix
programs.ssh.matchBlocks = {
  "builder" = {
    hostname = "nix-builder-hostname";
    user = "nix-builder";
    identityFile = "~/.ssh/builder-key";
    port = 2222;
  };
}
```

And that will be all. You are ready to use your new non-default port, mostly
safe from port scanners.
