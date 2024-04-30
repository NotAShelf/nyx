{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix fileContents;
  inherit (lib.attrsets) genAttrs;

  nvf = inputs.neovim-flake;
  inherit (nvf.lib.nvim.dag) entryBefore entryAnywhere;
in {
  config = {
    programs.neovim-flake = {
      enable = true;

      defaultEditor = true;
      enableManpages = true;

      settings = {
        vim = {
          # use neovim-unwrapped from nixpkgs
          # alternatively, neovim-nightly from the neovim-nightly overlay
          # via inputs.neovim-nightly.packages.${pkgs.system}.neovim
          package = pkgs.neovim-unwrapped;

          viAlias = true;
          vimAlias = true;

          withNodeJs = false;
          withPython3 = false;
          withRuby = false;

          preventJunkFiles = true;
          useSystemClipboard = true;
          spellcheck = {
            enable = true;
            languages = ["en"];
          };

          enableLuaLoader = true;
          enableEditorconfig = true;

          debugMode = {
            enable = false;
            logFile = "/tmp/nvim.log";
          };

          additionalRuntimePaths = let
            runtimeDir = builtins.path {
              path = ./runtime;
              name = "nvim-additional-runtime";
            };
          in [
            "${runtimeDir}/after"
            "${runtimeDir}/spell"
          ];

          # while I should be doing this in luaConfigRC below
          # I have come to realise that spellfile contents are
          # actually **not** loaded
          configRC.spellfile = entryAnywhere ''
            set spellfile=${toString ./spell/runtime/en.utf-8.add} " toString sanitizes the path
          '';

          luaConfigRC = let
            # get the name of each lua file in the lua directory, where setting files reside
            # and import tham recursively
            configPaths = filter (hasSuffix ".lua") (map toString (listFilesRecursive ./lua));

            # generates a key-value pair that looks roughly as follows:
            #  `<filePath> = entryAnywhere ''<contents of filePath>''`
            # which is expected by neovim-flake's modified DAG library
            luaConfig = genAttrs configPaths (file:
              entryBefore ["luaScript"] ''
                ${fileContents "${file}"}
              '');
          in
            luaConfig;
        };
      };
    };
  };
}
