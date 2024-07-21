{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config.modules = mkIf config.modules.profiles.workstation.enable {
    usrEnv = {
      programs = {
        git.enable = true;

        webcord.enable = true;
        element.enable = true;
        libreoffice.enable = true;
        firefox.enable = true;
        librewolf.enable = true;
        thunderbird.enable = true;
        zathura.enable = true;
        nextcloud.enable = true;
        dolphin.enable = true;

        editors.neovim.enable = true;
      };

      packages.cli.extraPackages = with pkgs; [
        libnotify
        imagemagick
        bitwarden-cli
        trash-cli
        slides
        brightnessctl
        pamixer
        nix-tree
      ];
    };
  };
}
