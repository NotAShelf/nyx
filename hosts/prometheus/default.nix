{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    #./ragenix.nix
  ];
}
