{
  imports = [
    ./cpu # cpu specific options
    ./gpu # gpu specific options
    ./multimedia # enable multimedia, sound and video

    ./tpm.nix # trusted platform module
    ./yubikey.nix # yubikey device support and management tools
    ./bluetooth.nix # bluetooth and device management
  ];
}
