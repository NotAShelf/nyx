{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./gitea
    ./tor
  ];
}
