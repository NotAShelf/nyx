{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) isAcceptedDevice;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  pkg = env.packages;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((isAcceptedDevice osConfig acceptedTypes) && pkg.cli.enable) {
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
