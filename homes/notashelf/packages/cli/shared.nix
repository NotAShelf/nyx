{
  osConfig,
  lib,
  pkgs,
  inputs',
  ...
}: let
  prg = osConfig.modules.programs;
in {
  config = lib.mkIf prg.cli.enable {
    home.packages = with pkgs; [
      # packages from inputs
      inputs'.agenix.packages.default
      inputs'.nyxpkgs.packages.cloneit

      # CLI packages from nixpkgs
      catimg
      duf
      todo
      hyperfine
      fzf
      file
      unzip
      ripgrep
      rsync
      grex
      fd
      jq
      figlet
      lm_sensors
      dconf
      cached-nix-shell
      ttyper
      nitch
      skim
      p7zip
      fastfetch
    ];
  };
}
