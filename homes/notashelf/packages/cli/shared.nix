{
  osConfig,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
in {
  config = (mkIf programs.cli.enable) {
    home.packages = with pkgs; [
      # packages from inputs
      inputs.agenix.packages.${pkgs.system}.default
      self.packages.${pkgs.hostPlatform.system}.cloneit

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
