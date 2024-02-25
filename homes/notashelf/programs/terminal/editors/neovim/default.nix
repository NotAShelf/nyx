{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString elem;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;

  mkModule = {
    path,
    illegalPaths ? [./plugins/sources/default.nix],
  }:
    filter (hasSuffix ".nix") (
      map toString (
        filter (p: p != ./default.nix && !elem p illegalPaths) (listFilesRecursive path)
      )
    );

  nvf = inputs.neovim-flake;
in {
  imports = lib.concatLists [
    # neovim-flake home-manager module
    [nvf.homeManagerModules.default]

    # constructed modules
    (mkModule {path = ./plugins;})
    (mkModule {path = ./mappings;})
  ];

  config = {
    programs.neovim-flake = {
      enable = true;
      settings = {
        vim = {
          package = pkgs.neovim-unwrapped;

          viAlias = true;
          vimAlias = true;

          enableEditorconfig = true;
          preventJunkFiles = true;
          enableLuaLoader = true;
          useSystemClipboard = true;
          spellChecking.enable = false;

          debugMode = {
            enable = false;
            logFile = "/tmp/nvim.log";
          };
        };

        vim = {
          autopairs.enable = true;

          telescope.enable = true;

          git = {
            enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions = false;
          };

          minimap = {
            # cool for vanity but practically useless on small screens
            minimap-vim.enable = false;
            codewindow.enable = false;
          };

          dashboard = {
            dashboard-nvim.enable = false;
            alpha.enable = true;
          };

          notify = {
            nvim-notify.enable = true;
          };

          luaConfigRC = {
            # additional LSP handler configurations via vim.lsp.handlers
            "lsp-handler" = builtins.readFile ./lua/handlers.lua;

            # additional neovide configuration
            "neovide" = builtins.readFile ./lua/neovide.lua;
          };
        };
      };
    };

    xdg.desktopEntries."neovim" = lib.mkForce {
      name = "Neovim";
      type = "Application";
      mimeType = ["text/plain"];

      icon = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/NotAShelf/neovim-flake/main/assets/neovim-flake-logo-work.svg";
        sha256 = "19n7n9xafyak35pkn4cww0s5db2cr97yz78w5ppbcp9jvxw6yyz3";
      };

      exec = let
        wezterm = lib.getExe config.programs.wezterm.package;
        direnv = lib.getExe pkgs.direnv;
      in "${pkgs.writeShellScript "wezterm-neovim" ''
        filename = "$(readlink -f "$1")" # define target filename
        dirname = "$(dirname "$filename")" # get the directory target file is in

        # launch a wezterm instance with direnv and nvim
        ${wezterm} start --cwd "$dirname" -- ${lib.getExe pkgs.zsh} -c "${direnv} exec . nvim '$filename'"
      ''} %f";
    };
  };
}
