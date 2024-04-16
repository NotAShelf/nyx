{
  programs.ripgrep = {
    enable = true;

    # <https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file>
    arguments = [
      # Don't have ripgrep vomit a bunch of stuff on the screen
      # show a preview of the match
      "--max-columns=150"
      "--max-columns-preview"

      # ignore git files
      "--glob=!.git/*"

      #
      "--smart-case"
    ];
  };
}
