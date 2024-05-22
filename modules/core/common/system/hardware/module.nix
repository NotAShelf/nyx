{
  imports = [
    ./cpu # cpu specific options
    ./gpu # gpu specific options
    ./multimedia # enable multimedia: e.g. sound and video

    ./bluetooth.nix # bluetooth and device management
    ./tpm.nix # trusted platform module
    ./yubikey.nix # yubikey device support and management tools
    ./redistributable.nix # Non-free redstributable software
  ];
}
