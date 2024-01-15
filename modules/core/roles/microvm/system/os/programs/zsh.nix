{
  environment.pathsToLink = ["/share/zsh"];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      async = true;
    };
  };
}
