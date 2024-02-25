{
  imports = [
    ./cpu # cpu specific options
    ./gpu # gpu specific options
    ./multimedia # enable multimedia: e.g. sound and video

    ./bluetooth.nix # bluetooth and device management
    ./generic.nix # host-agnostic options and settings
    ./tpm.nix # trusted platform module
    ./yubikey.nix # yubikey device support and management tools
  ];
}
