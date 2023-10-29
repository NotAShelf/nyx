_: {
  # variables that I want to set globally on all systems

  environment.variables = {
    FLAKE = "/home/notashelf/.config/nyx";
    SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";

    # editors
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";

    # pager stuff
    SYSTEMD_PAGERSECURE = "true";
    PAGER = "less -FR";
    MANPAGER = "nvim +Man!";
  };
}
