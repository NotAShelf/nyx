{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    binwalk
    binutils
    diffoscopeMinimal
    nmap
  ];
}
