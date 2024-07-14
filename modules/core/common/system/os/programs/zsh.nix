{
  # While we do have zsh enabled in userspace (i.e. home-manager) we also
  # need it set system-wide since zsh will be our login shell.
  programs.zsh = {
    enable = true;

    shellInit = ''
      # Make sure we always use the correct zsh dotdir.
      export ZDOTDIR=$HOME/.config/zsh
    '';

    # We actually like zsh completion, but its setup belongs in home-manager
    # configuration to better support standalone home-manager installations. We
    # disable completion here to save time by avoiding duplicate compinit calls
    # and other similar duplications. Despite being disabled here, zsh will be
    # able to complete for my home-manager user.
    # See:
    #  <https://github.com/nix-community/home-manager/issues/3965>
    enableCompletion = false;
  };
}
