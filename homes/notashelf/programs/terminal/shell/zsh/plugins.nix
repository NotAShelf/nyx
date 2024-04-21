{pkgs, ...}: let
  inherit (pkgs) fetchFromGitHub;
in {
  programs.zsh.plugins = [
    {
      # Must be before plugins that wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting
      name = "fzf-tab";
      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
    }
    {
      name = "zsh-nix-shell";
      src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh";
    }
    {
      name = "zsh-vi-mode";
      src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
    {
      name = "fast-syntax-highlighting";
      src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    }
    {
      name = "zsh-autosuggestions";
      src = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "zsh-autopair";
      file = "zsh-autopair.plugin.zsh";
      src = fetchFromGitHub {
        owner = "hlissner";
        repo = "zsh-autopair";
        rev = "2ec3fd3c9b950c01dbffbb2a4d191e1d34b8c58a";
        hash = "sha256-Y7fkpvCOC/lC2CHYui+6vOdNO8dNHGrVYTGGNf9qgdg=";
      };
    }
  ];
}
