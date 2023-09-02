{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      alejandra
      deadnix
      statix
      nix-tree
      # perl # for shasum
    ];

    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };
}
