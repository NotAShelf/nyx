{
  programs.neovim-flake.settings.vim = {
    projects = {
      project-nvim = {
        enable = true;
        manualMode = false;
        detectionMethods = ["lsp" "pattern"];
        patterns = [
          ".git"
          ".hg"
          "Makefile"
          "package.json"
          "index.*"
          ".anchor"
          "flake.nix"
        ];
      };
    };
  };
}
