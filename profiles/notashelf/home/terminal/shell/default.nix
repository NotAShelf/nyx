{...}: {
  imports = [
    ./git.nix
    ./starship.nix
    ./zsh.nix
    ./nix-shell.nix
  ];

  programs = {
    exa.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
