{
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;

  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [inputs.spicetify.homeManagerModules.default];
  config = mkIf prg.spotify.enable {
    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        powerBar
        hidePodcasts
        songStats
        shuffle
        history
        betterGenres
        fullScreen
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
