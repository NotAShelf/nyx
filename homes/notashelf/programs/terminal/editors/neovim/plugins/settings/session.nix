{
  programs.neovim-flake.settings.vim = {
    session.nvim-session-manager = {
      enable = false;
      setupOpts.autoload_mode = "Disabled"; # misbehaves with dashboard
    };
  };
}
