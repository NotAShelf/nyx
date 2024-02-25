{
  programs.neovim-flake.settings.vim = {
    session.nvim-session-manager = {
      enable = false;
      autoloadMode = "Disabled"; # misbehaves with dashboard
    };
  };
}
