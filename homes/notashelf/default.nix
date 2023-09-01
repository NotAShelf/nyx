{
  self,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    # imported home-manager modules
    self.homeManagerModules.xplr
    self.homeManagerModules.gtklock

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
  };
}
