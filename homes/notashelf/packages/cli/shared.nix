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
      self.packages.${pkgs.hostPlatform.system}.fastfetch
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
      skim
      p7zip
    ];
  };
}
