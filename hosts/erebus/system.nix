# NixOS livesystem to generate yubikeys in an air-gapped manner
# screenshot: https://dl.thalheim.io/ZF5Y0yyVRZ_2MWqX2J42Gg/2020-08-12_16-00.png
# $ nixos-generate -f iso -c yubikey-image.nix
#
# to test it in a vm:
#
# $ nixos-generate --run -f vm -c yubikey-image.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  drduhConfig = pkgs.fetchFromGitHub {
    owner = "drduh";
    repo = "config";
    rev = "6bea1fdaa8732ec8625f4bac7022b25e14b15ffe";
    hash = "sha256-Fto8FCVYeKviMz0VmCiXHrgMT1pVopJGGDHF0s3K4ts=";
  };

  gpg-conf = "${drduhConfig}/gpg.conf";

  yubico-guide = pkgs.stdenv.mkDerivation {
    name = "yubikey-guide.html";
    src = pkgs.fetchFromGitHub {
      owner = "drduh";
      repo = "YubiKey-Guide";
      rev = "fec6e92b8f05c899eccc7f2f2b273d609ed6094e";
      hash = "sha256-N76e/yhXUoWUK6EQZHGyTs0DcbZqAlI5xtQMf0squR8=";
    };
    buildInputs = [pkgs.pandoc];
    installPhase = "pandoc --highlight-style pygments -s --toc README.md -o $out";
  };

  guide = "${yubico-guide}/README.md";
  contrib = "${yubico-guide}/contrib";

  # Instead of hard-coding the pinentry program, chose the appropriate one
  # based on the environment of the image the user has chosen to build.
  gpg-agent-conf = pkgs.runCommand "gpg-agent.conf" {} ''
    sed '/pinentry-program/d' ${drduhConfig}/gpg-agent.conf > $out
    echo "pinentry-program ${pkgs.pinentry.${pinentryFlavour}}/bin/pinentry" >> $out
  '';

  xserverCfg = config.services.xserver;
  pinentryFlavour =
    if xserverCfg.desktopManager.lxqt.enable || xserverCfg.desktopManager.plasma5.enable
    then "qt"
    else if xserverCfg.desktopManager.xfce.enable
    then "gtk2"
    else if xserverCfg.enable || config.programs.sway.enable
    then "gnome3"
    else "curses";

  view-yubikey-guide = pkgs.writeShellScriptBin "view-yubikey-guide" ''
    viewer="$(type -P xdg-open || true)"
    if [ -z "$viewer" ]; then
      viewer="${pkgs.glow}/bin/glow -p"
    fi
    exec $viewer "${guide}"
  '';

  shortcut = pkgs.makeDesktopItem {
    name = "yubikey-guide";
    icon = "${pkgs.yubikey-manager-qt}/share/ykman-gui/icons/ykman.png";
    desktopName = "drduh's YubiKey Guide";
    genericName = "Guide to using YubiKey for GPG and SSH";
    comment = "Open the guide in a reader program";
    categories = ["Documentation"];
    exec = "${view-yubikey-guide}/bin/view-yubikey-guide";
  };

  yubikey-guide = pkgs.symlinkJoin {
    name = "yubikey-guide";
    paths = [view-yubikey-guide shortcut];
  };
in {
  environment.interactiveShellInit = ''
    # unset HISTFILE
    export GNUPGHOME="/run/user/$(id -u)/gnupg"
    if [ ! -d "$GNUPGHOME" ]; then
      echo "Creating \$GNUPGHOME…"
      install --verbose -m=0700 --directory="$GNUPGHOME"
    fi
    [ ! -f "$GNUPGHOME/gpg.conf" ] && cp --verbose ${gpg-conf} "$GNUPGHOME/gpg.conf"
    [ ! -f "$GNUPGHOME/gpg-agent.conf" ] && cp --verbose ${gpg-agent-conf} "$GNUPGHOME/gpg-agent.conf"
    echo "\$GNUPGHOME is \"$GNUPGHOME\""
  '';

  # Secure defaults
  nixpkgs.config = {allowBroken = false;};
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

  # Yubikey Tooling
  isoImage.isoBaseName = lib.mkForce "nixos-yubikey";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    yubikey-personalization
    cryptsetup
    pwgen
    midori
    paperkey
    gnupg
    ctmg
  ];

  #
  services.udev.packages = with pkgs; [yubikey-personalization];
  services.pcscd.enable = true;

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Copy the contents of contrib to the home directory, add a shortcut to
  # the guide on the desktop, and link to the whole repo in the documents
  # folder.
  system.activationScripts.yubikeyGuide = let
    homeDir = "/home/nixos/";
    desktopDir = homeDir + "Desktop/";
    documentsDir = homeDir + "Documents/";
  in ''
    mkdir -p ${desktopDir} ${documentsDir}
    chown nixos ${homeDir} ${desktopDir} ${documentsDir}

    cp -R ${contrib}/* ${homeDir}
    ln -sf ${yubikey-guide}/share/applications/yubikey-guide.desktop ${desktopDir}
    ln -sfT ${yubikey-guide} ${documentsDir}/YubiKey-Guide
  '';

  services.xserver = {
    enable = true;
    layout = "tr";
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "yubikey";
    displayManager.defaultSession = "none+i3";
    displayManager.sessionCommands = ''
      ${pkgs.zathura}/bin/zathura ${guide} &
      ${pkgs.kitty}/bin/kitty &
    '';

    desktopManager = {
      xterm.enable = false;
    };

    # i3 for window management
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
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

    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };
}
