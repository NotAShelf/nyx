{
  imports = [
    ./bash.nix
    ./direnv.nix
    ./nano.nix
    ./zsh.nix
  ];

  programs = {
    # less pager
    less.enable = true;

    # run commands without installing the programs
    comma.enable = true;

    # type "fuck" to fix the last command that made you go "fuck"
    thefuck.enable = true;
  };
}
