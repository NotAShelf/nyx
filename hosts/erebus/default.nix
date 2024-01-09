{
  imports = [
    ./system # system configuration
    ./virtualization.nix # configure virtual machine
    ./yubikey.nix # configure yubikey toolkit
  ];
}
