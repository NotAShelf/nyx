{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      alejandra
      nix-tree
    ];
  };
}
