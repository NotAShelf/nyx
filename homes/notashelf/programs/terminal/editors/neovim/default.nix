{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString elem;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix fileContents removeSuffix;
  inherit (lib.attrsets) genAttrs;

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

          luaConfigRC = let
            inherit (nvf.lib.nvim.dag) entryAnywhere;

            # get the name of each lua file in the lua directory, where setting files reside
            configPaths = map (f: removeSuffix ".lua" f) (filter (hasSuffix ".lua") (map toString (listFilesRecursive ./lua)));

            # get the path of each file by removing the ./. prefix from each element in the list
            configNames = map (p: removeSuffix "./" p) configPaths;

            # generate a key-value pair that looks roughly as follows:
            # "fileName" = entryAnywhere "<contents of ./lua/fileName.lua>"
            # which is expected by neovim-flake's modified DAG library
            luaConfig = genAttrs configNames (name:
              entryAnywhere ''
                ${fileContents "${name}.lua"}
              '');
          in
            luaConfig;
        };
      };
    };
  };
}
