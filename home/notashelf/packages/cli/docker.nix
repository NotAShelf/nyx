{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    docker-compose
    docker-credential-helpers
  ];
}
