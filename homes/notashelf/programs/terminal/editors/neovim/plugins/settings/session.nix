{
  programs.nvf.settings.vim = {
    session.nvim-session-manager = {
      enable = false;
      setupOpts.autoload_mode = "Disabled"; # misbehaves with dashboard
    };
  };
}
