{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };
}
