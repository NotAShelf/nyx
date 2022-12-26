{
  inputs,
  self,
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

  cloneit = self.packages.${pkgs.system}.cloneit;
in {
  home.packages = with pkgs; [
    # Graphical
    thunderbird
    tdesktop
    lutris
    dolphin-emu
    qbittorrent
    quasselClient
    bitwarden
    xfce.thunar
    obsidian
    nextcloud-client
    #gnome.gnome-control-center # TODO: figure out why this fails to build
    gnome.gnome-calendar
    pavucontrol
    ungoogled-chromium

    # CLI
    cloneit
    todo
    mpv-unwrapped
    yt-dlp
    hyperfine
    fzf
    unzip
    ripgrep
    rsync
    imagemagick
    bandwhich
    grex
    fd
    xh
    jq
    figlet
    lm_sensors
    bitwarden-cli
    dconf
    gcc
    cmake
    trash-cli
    cached-nix-shell
    ttyper
    docker-compose
    docker-credential-helpers
    xorg.xhost
    mov-cli
    nitch
  ];
}
