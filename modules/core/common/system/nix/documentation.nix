{
  # faster rebuilding
  documentation = {
    # whether to enable the `doc` output of packages
    # generally in ${pkg}/share/ as plaintext or html
    # can shave off a few megabytes
    doc.enable = false;

    # whether to install the `info` command and the `info`
    # output of packages
    info.enable = false;

    nixos = {
      # I need this enabled for the anyrun-nixos-options plugin
      # but otherwise, it should be disabled to avoid unnecessary rebuilds.
      # Includes:
      # - man pages like configuration.nix(5) if documentation.man.enable is set.
      # - the HTML manual and the nixos-help command if documentation.doc.enable is set.
      # This actually causes the source tree of nixpkgs to be re-evaluated. See:
      # <https://mastodon.online/@nomeata/109915786344697931>
      enable = true;
      options = {
        warningsAreErrors = true;
        splitBuild = true;
      };
    };

    man = {
      # Whether to install manual pages
      # this means packages that provide a `man` output will have said output
      # included in the final closure
      enable = true;

      # Whether to generate the manual page index caches
      # if true, it becomes possible to search for a page or keyword
      # using utilities like apropos(1) and the -k option of man(1).
      generateCaches = true;

      # Whether to enable mandoc as the default man page viewer.
      mandoc.enable = false; # my default manpage viewer is Neovim, so this isn't necessary
    };
  };
}
