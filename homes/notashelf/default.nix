{
  self,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    # imported home-manager modules
    self.homeManagerModules.gtklock # a home-manager module for gtklock, gotta upstream it eventually

    # home package sets
    ./packages

    # programs and services that I use
    ./programs
    ./services

    # declarative system and program themes (qt/gtk)
    ./themes
  ];

  config = {
    home = {
      username = "notashelf";
      homeDirectory = "/home/notashelf";
      extraOutputsToInstall = ["doc" "devdoc"];

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      # I will personally strangle every moron who just puts nothing but "DONT CHANGE" next
      # to this value
      stateVersion = mkDefault "23.05";
    };

    manual = {
      # the docs suck, so we disable them to save space
      html.enable = false;
      json.enable = false;
      manpages.enable = true;
    };

    # let HM manage itself when in standalone mode
    programs.home-manager.enable = true;

    # reload system units when changing configs
    systemd.user.startServices = mkDefault "sd-switch"; # or "legacy" if "sd-switch" breaks again
  };
}
