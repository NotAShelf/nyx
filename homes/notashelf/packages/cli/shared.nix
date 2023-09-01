{
  osConfig,
  lib,
  pkgs,
  inputs,
  self,
  ...
}: {
  config = (lib.mkIf osConfig.modules.usrEnv.programs.cli.enable) {
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
      grex
      fd
      xh
      jq
      figlet
      lm_sensors
      dconf
      cached-nix-shell
      ttyper
      nitch
      skim
      p7zip
    ];
  };
}
