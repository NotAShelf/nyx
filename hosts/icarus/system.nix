{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../system/serv/services.nix
    ../../system/common.nix
  ];
}
