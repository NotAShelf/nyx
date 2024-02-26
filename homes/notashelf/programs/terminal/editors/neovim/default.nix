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

    # construct this entire directory as a module
    # which means all default.nix files will be imported automatically
    (mkModule {path = ./.;})
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
            # autocommands
            "autocommands" = builtins.readFile ./lua/autocommands.lua;

            # additional LSP handler configurations via vim.lsp.handlers
            "lsp-handler" = builtins.readFile ./lua/handlers.lua;

            # configurations that don't belong anywhere else
            "misc" = builtins.readFile ./lua/misc.lua;

            # additional neovide configuration
            "neovide" = builtins.readFile ./lua/neovide.lua;
          };
        };
      };
    };
  };
}
