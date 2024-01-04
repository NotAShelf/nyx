{
  imports = [
    ./newsboat
    ./xplr
    ./vifm
    ./yazi

    ./bat.nix
    ./bottom.nix
    ./dircolors.nix
    ./eza.nix
    ./git.nix
    ./nix-shell.nix
    ./tealdeer.nix
    ./transient-services.nix
    ./zoxide.nix
  ];

  programs = {
    man.enable = true;
  };
}
