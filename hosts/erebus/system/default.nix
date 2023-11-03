# NixOS livesystem to generate yubikeys in an air-gapped manner
# $ nix build .#images.erebus
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Secure defaults
  nixpkgs.config = {allowBroken = false;}; # false breaks zfs kernel - but we don't care about zfs

  # Always copytoram so that, if the image is booted from, e.g., a
  # USB stick, nothing is mistakenly written to persistent storage.
  boot = {
    kernelParams = ["copytoram"];
    tmp.cleanOnBoot = true;
    kernel.sysctl = {"kernel.unprivileged_bpf_disabled" = 1;};
  };

  # make sure we are air-gapped
  networking = {
    wireless.enable = false;
    dhcpcd.enable = false;
  };

  services.getty.helpLine = "The 'root' account has an empty password.";

  isoImage.isoBaseName = lib.mkForce config.networking.hostName;

  # words cannot express how much I hate zfs
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  environment = {
    # needed for i3blocks
    pathsToLink = ["/libexec"];
    # fix an annoying warning
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };

  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-color-emoji
    ];
  };
}
