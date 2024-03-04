{pkgs, ...}: {
  programs.neovim-flake.settings.vim = {
    treesitter = {
      fold = true;
      context.enable = true;

      # extra grammars that will be installed by Nix
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        regex # for regexplainer
        kdl # zellij configurations are in KDL, I want syntax highlighting
      ];
    };
  };
}
