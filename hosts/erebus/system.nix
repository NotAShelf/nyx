# NixOS livesystem to generate yubikeys in an air-gapped manner
# screenshot: https://dl.thalheim.io/ZF5Y0yyVRZ_2MWqX2J42Gg/2020-08-12_16-00.png
# $ nixos-generate -f iso -c yubikey-image.nix
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Secure defaults
  nixpkgs.config = {allowBroken = true;}; # false breaks zfs kernel
  # Always copytoram so that, if the image is booted from, e.g., a
  # USB stick, nothing is mistakenly written to persistent storage.
  boot.kernelParams = ["copytoram"];
  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {"kernel.unprivileged_bpf_disabled" = 1;};

  # make sure we are air-gapped
  networking.wireless.enable = false;
  networking.dhcpcd.enable = false;

  services.getty.helpLine = "The 'root' account has an empty password.";

  security.sudo.wheelNeedsPassword = false;
  users.users.yubikey = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = "/run/current-system/sw/bin/bash";
  };

  isoImage.isoBaseName = lib.mkForce config.networking.hostName;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.xserver = {
    enable = true;
    layout = "tr";
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "yubikey";
    displayManager.defaultSession = "none+i3";

    desktopManager = {
      xterm.enable = false;
    };

    # i3 for window management
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      extraPackages = with pkgs; [
        st # suckless terminal that sucks, pretty minimal though
        rofi # alternative to dmenu, usually better
        dmenu # application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock # default i3 screen locker
        i3blocks # if you are planning on using i3blocks over i3status
      ];
    };
  };

  # needed for i3blocks
  environment.pathsToLink = ["/libexec"];
  programs.dconf.enable = true;

  services.gvfs.enable = true;

  services.autorandr.enable = true;
  programs.nm-applet.enable = true;

  fonts = {
    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    fontconfig.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
}
