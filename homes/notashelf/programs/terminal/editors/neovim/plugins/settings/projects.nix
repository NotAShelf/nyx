{
  programs.nvf.settings.vim = {
    projects = {
      project-nvim = {
        enable = true;
        setupOpts = {
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
  };
}
