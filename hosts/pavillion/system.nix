{
  config,
  pkgs,
  ...
}: {
    imports = [
        ../../system/graphical/nvidia.nix
        ../../system/graphical/gamemode.nix
        ../../system/graphical/xserver.nix
        ../../system/desktop/programs.nix
        ../../system/desktop/services.nix
    ];

    
    # Keep systemd-boot as the default bootloader
    loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 1;
    };
}
