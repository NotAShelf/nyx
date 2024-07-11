{pkgs, ...}: {
  # type "fuck" to fix the last command that made you go "fuck"
  programs.thefuck = {
    enable = false;
    package = pkgs.thefuck.overridePythonAttrs {doCheck = false;};
  };
}
