{pkgs, ...}: {
  imports = [
    ./bottom
    ./newsboat
    ./tealdeer
    ./ranger
    ./xplr
    ./bat
    ./git

    ./nix-shell.nix
    ./run-transient-services.nix
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
