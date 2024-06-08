{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString path isPath throw;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix fileContents;
  inherit (lib.attrsets) genAttrs;

  nvf = inputs.neovim-flake;
  inherit (nvf.lib.nvim.dag) entryBefore entryAnywhere;

  mkRuntimeDir = name: let
    finalPath = ./runtime + /${name};
  in
    path {
      name = "nvim-runtime-${name}";
      path = toString finalPath;
    };
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
          # via inputs.neovim-nightly.packages.${pkgs.stdenv.system}.neovim
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

          additionalRuntimePaths = [
            (mkRuntimeDir "after")
            (mkRuntimeDir "spell")
          ];

          # while I should be doing this in luaConfigRC below
          # I have come to realise that spellfile contents are
          # actually **not** loaded when luaConfigRC is used.
          # as spellfile is a vim thing, this should be fine
          configRC.spellfile = entryAnywhere ''
            set spellfile=${toString ./spell/runtime/en.utf-8.add} " toString sanitizes the path
          '';

          # additional lua configuration that I can append
          # or, to be more precise, randomly inject into
          # the lua configuration of my Neovim configuration
          # wrapper. this is recursively read from the lua
          # directory, so we do not need to use require
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
