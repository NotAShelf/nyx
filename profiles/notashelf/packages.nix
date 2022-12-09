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
  webcord = inputs.webcord.packages.${pkgs.system}.default.override {
    flags = let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "discord";
        rev = "159aac939d8c18da2e184c6581f5e13896e11697";
        sha256 = "sha256-cWpog52Ft4hqGh8sMWhiLUQp/XXipOPnSTG6LwUAGGA=";
      };

      theme = "${catppuccin}/themes/mocha.theme.css";
    in ["--add-css-theme=${theme}"];
  };
in {
  home.packages = with pkgs; [
    # Graphical
    webcord
    thunderbird
    tdesktop
    lutris
    dolphin-emu
    qbittorrent
    quasselClient
    keepassxc
    bitwarden
    xfce.thunar
    obsidian

    # CLI
    cloneit
    todo
    mpv-unwrapped
    yt-dlp
    pavucontrol
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
    trash-cli
    cached-nix-shell
  ];
}
