{pkgs, ...}: {
  config = {
    home.packages = [
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
