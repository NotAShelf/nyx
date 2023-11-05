{pkgs, ...}: {
  imports = [
    ./bottom
    ./newsboat
    ./ranger
    ./xplr
    ./bat
    ./vifm

    ./git.nix
    ./nix-shell.nix
    ./run-transient-services.nix
    ./tealdeer.nix
  ];
  programs = {
    man.enable = true;

    eza = {
      enable = true;
      icons = true;
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
      settings = {
        OTHER_WRITABLE = "30;46";
        ".sh" = "01;32";
        ".csh" = "01;32";
      };
    };
  };
}
