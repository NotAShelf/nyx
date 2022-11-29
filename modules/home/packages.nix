{
  inputs,
  pkgs,
  config,
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

  webcord = inputs.webcord.packages.${pkgs.system}.default;
  cloneit = inputs.self.packages.${pkgs.system}.cloneit;
in {
  nixpkgs.config.allowUnfree = false;
  home.packages = with pkgs; [
    webcord
    cloneit
    todo
    mpv-unwrapped
    yt-dlp
    pavucontrol
    hyperfine
    fzf
    gum
    unzip
    ripgrep
    rsync
    imagemagick
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
    bitwarden
    bitwarden-cli
    dconf
    gcc
    thunderbird
    tdesktop
    lutris
    dolphin-emu
    qbittorrent
    quasselClient
  ];
}
