{
  osConfig,
  lib,
  pkgs,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.system.programs;
in {
  config = mkIf prg.cli.enable {
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
      fd
      jq
      figlet
      lm_sensors
      dconf
      nitch
      skim
      p7zip
      btop
    ];
  };
}
