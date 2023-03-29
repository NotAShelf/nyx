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
    inputs.neovim-flake.homeManagerModules.default

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
    systemd.user.startServices = "sd-switch"; # or "legacy" if "sd-switch" breaks again

    home = {
      username = "notashelf";
      homeDirectory = "/home/notashelf";

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      # I will personally strangle every moron who just puts nothing but "DONT CHANGE" next
      # to this value
      stateVersion = "23.05";
      extraOutputsToInstall = ["doc" "devdoc"];
    };

    manual = {
      # the docs suck, so we disable them to save space
      html.enable = false;
      json.enable = false;
      manpages.enable = false;
    };

    # let HM manage itself when in standalone mode
    programs.home-manager.enable = true;
    programs.neovim-flake = {
      enable = false;
      settings = {
        vim.viAlias = true;
        vim.vimAlias = true;
      };
    };

    modules = {
      programs = {
        # cozy neovim config with catppuccin colors
        cnvim.enable = true;

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
  };
}
