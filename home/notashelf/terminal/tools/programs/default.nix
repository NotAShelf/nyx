{pkgs, ...}: {
  imports = [
    ./bottom
    ./newsboat
    ./ranger
    ./xplr
    ./bat

    ./git.nix
    ./nix-shell.nix
    ./run-transient-services.nix
    ./tealdeer.nix
  ];
  programs = {
    man.enable = true;

    exa = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

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
