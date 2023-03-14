{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    # external home-manager modules
    inputs.hyprland.homeManagerModules.default

    # home package sets
    ./packages

    # apps and services I use
    ./graphical
    ./terminal
    ./services
    ./gaming

    # declarative system and program theme
    ./themes
  ];
  config = {
    # reload system units when changing configs
    # systemd.user.startServices = "sd-switch";

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Install.WantedBy = ["graphical-session.target"];
      Unit.PartOf = ["graphical-session.target"];
      Service.ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };

    home = {
      username = "notashelf";
      homeDirectory = "/home/notashelf";
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      # I will personally strangle every moron who just puts "DONT CHANGE" next
      # to this value
      stateVersion = "23.05";
      extraOutputsToInstall = ["doc" "devdoc"];
    };

    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = false;
    };

    # let HM manage itself when in standalone mode
    programs.home-manager.enable = true;

    modules = {
      programs = {
        # cozy neovim config with catppuccin colors
        cnvim.enable = true;

        # schizo firefox config based on firefox ESR
        schizofox = {
          enable = true;
          netflixDRMFix = true;
          extraSecurity = false;
          translate = {
            enable = true;
            sourceLang = "en";
            targetLang = "tr";
          };
        };
      };
    };
  };
}
