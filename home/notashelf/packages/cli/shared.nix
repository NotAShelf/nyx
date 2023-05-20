{
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
in {
  config = (mkIf programs.cli.enable) {
    home.packages = with pkgs; [
      inputs.agenix.packages.${pkgs.system}.default
      # CLI
      cloneit
      catimg
      duf
      todo
      hyperfine
      fzf
      file
      unzip
      ripgrep
      rsync
      bandwhich
      grex
      fd
      xh
      jq
      figlet
      lm_sensors
      dconf
      cached-nix-shell
      ttyper
      xorg.xhost
      nitch
      fastfetch
      skim
    ];
  };
}
