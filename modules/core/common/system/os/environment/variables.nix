{lib, ...}: let
  inherit (lib.strings) concatStringsSep;
  pagerArgs = [
    "--RAW-CONTROL-CHARS" # Only allow colors.
    "--wheel-lines=5"
    "--LONG-PROMPT"
    "--no-vbell"
    " --wordwrap" # Wrap lines at spaces.
  ];
in {
  # variables that I want to set globally on all systems

  environment.variables = {
    SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";

    # editors
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";

    # pager stuff
    MANPAGER = "nvim -c 'set ft=man bt=nowrite noswapfile nobk shada=\\\"NONE\\\" ro noma' +Man! -o -";
    SYSTEMD_PAGERSECURE = "true";
    PAGER = "less -FR";
    LESS = concatStringsSep " " pagerArgs;
    SYSTEMD_LESS = concatStringsSep " " (pagerArgs
      ++ [
        "--quit-if-one-screen"
        "--chop-long-lines"
        "--no-init" # Keep content after quit.
      ]);
  };
}
