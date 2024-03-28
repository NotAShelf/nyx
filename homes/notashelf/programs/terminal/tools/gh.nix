{pkgs, ...}: {
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = false;
    extensions = with pkgs; [
      gh-dash # dashboard with pull requests and issues
      gh-eco # explore the ecosystem
      gh-cal # contributions calender terminal viewer
      gh-poi # clean up local branches safely
    ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
