{
  config,
  lib,
  ...
}: {
  config = {
    services.smartd.enable = lib.mkForce false;

    boot = {
      growPartition = !config.boot.initrd.systemd.enable;
      kernel = {
        sysctl = {
          # # Enable IP forwarding
          # required for Tailscale subnet feature
          # https://tailscale.com/kb/1019/subnets/?tab=linux#step-1-install-the-tailscale-client
          # also wireguard
          "net.ipv4.ip_forward" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };
      };

      loader.grub = {
        enable = true;
        useOSProber = lib.mkForce false;
        efiSupport = lib.mkForce false;
        enableCryptodisk = false;
        theme = null;
        backgroundColor = null;
        splashImage = null;
        device = lib.mkForce "/dev/vda";
      };
    };
  };
}
