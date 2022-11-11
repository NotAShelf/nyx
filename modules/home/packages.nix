{
  inputs,
  pkgs,
  config,
  self,
  ...
}: let
  mpv-unwrapped = pkgs.mpv-unwrapped.overrideAttrs (o: {
    src = pkgs.fetchFromGitHub {
      owner = "mpv-player";
      repo = "mpv";
      rev = "48ad2278c7a1fc2a9f5520371188911ef044b32c";
      sha256 = "sha256-6qbv34ysNQbI/zff6rAnVW4z6yfm2t/XL/PF7D/tjv4=";
    };
  });

  # My own packages
  cloneit = self.packages.${pkgs.system}.cloneit;
  battop = self.packages.${pkgs.system}.battop;
  proton-ge = self.packages.${pkgs.system}.proton;
in {
  nixpkgs = {
    config.allowUnfree = true;
  };
  home.packages = with pkgs; [
    cloneit
    battop
    proton-ge
    todo
    upower
    mpv-unwrapped
    pavucontrol
    imv
    hyperfine
    fzf
    gum
    unzip
    gnupg
    ripgrep
    rsync
    nano
    imagemagick
    unrar
    killall
    bandwhich
    grex
    fd
    xfce.thunar
    xh
    jq
    figlet
    lm_sensors
    keepassxc
    dconf
    gcc
    rustc
    cargo
    thunderbird
    acpi
    tlp
    powertop
    geoclue2
    nextcloud-client
    libgdiplus
    wireshark

    # overlay packages
    #emacs
    #discord-openasar
  ];
}
