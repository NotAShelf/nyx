{
  programs = {
    zsh.enable = true;
    dconf.enable = true;

    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
