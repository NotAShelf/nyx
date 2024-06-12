{pkgs, ...}: {
  config = {
    home.packages = [
      # LaTeX
      pkgs.texlive.combined.scheme-full
      (pkgs.writeShellApplication {
        name = "pdflatexmk";
        runtimeInputs = [pkgs.texlivePackages.latexmk];
        text = ''
          latexmk -pdf "$@" && latexmk -c "$@"
        '';
      })
    ];
  };
}
