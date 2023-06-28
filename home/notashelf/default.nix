{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    # external home-manager modules
    inputs.hyprland.homeManagerModules.default

    # home package sets
    ./packages

    # apps and services I use
    ./graphical # graphical apps
    ./terminal # terminal emulators and terminal-first programs
    ./services # system services, organized by display protocol

    # declarative system and program themes (qt/gtk)
    ./themes
  ];
  config = {
    # reload system units when changing configs
    systemd.user.startServices = mkDefault "sd-switch"; # or "legacy" if "sd-switch" breaks again

    home = {
      username = "notashelf";
      homeDirectory = "/home/notashelf";

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      # I will personally strangle every moron who just puts nothing but "DONT CHANGE" next
      # to this value
      stateVersion = mkDefault "23.05";
      extraOutputsToInstall = ["doc" "devdoc"];
    };

    manual = {
      # the docs suck, so we disable them to save space
      html.enable = false;
      json.enable = false;
      manpages.enable = true;
    };

    # let HM manage itself when in standalone mode
    programs.home-manager.enable = true;

    /*
    modules = {
      programs = {
        # schizo firefox config based on firefox ESR
        schizofox = {
          enable = true;
          netflixDRMFix = true;
          extraSecurity = true;
          extremeSecurity = false;
          translate = {
            enable = true;
            sourceLang = "en";
            targetLang = "tr";
          };
        };
      };
    };
    */
  };
}
