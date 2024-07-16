{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  prg = config.modules.system.programs;
in {
  config = mkIf prg.gaming.steam.enable {
    programs.steam = {
      # Enable steam
      enable = true;

      # An attempt to reduce the closure size of Steam (which by default is *massive* - around 15 gigs)
      # This removes game-specific libraries crammed into the Steam runtime
      # by upstream (nixpkgs) packaging to mitigate errors due to missing libraries.
      # As we strip those libraries, we gain space and lose compatibility - which
      # unfortunately means that it is up to *us* to identify necessary libraries
      # and stick them here.
      package = pkgs.steam-small.override {
        extraEnv = {
          MANGOHUD = true;
          SDL_VIDEODRIVER = "x11";
        };

        extraLibraries = ps:
          with ps; [
            atk
            # for Titanfall 2 Northstar launcher
            libunwind
          ];
      };

      # Whether to open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = false;

      # Whether to open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = false;

      # Compatibility tools to install
      # For the accepted format (and the reason behind)
      # the "compattool" attribute, see:
      # <https://github.com/NixOS/nixpkgs/pull/296009>
      extraCompatPackages = [
        pkgs.proton-ge-bin.steamcompattool
      ];
    };

    # udev rules for various controller compatibility.
    services.udev.extraRules = ''
      # This rule is needed for basic functionality of the controller in
      # Steam and keyboard/mouse emulation
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
      # Valve HID devices over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
      # Valve HID devices over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
      # DualShock 4 over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
      # Dualsense over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666"
      # DualShock 4 wireless adapter over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
      # DualShock 4 Slim over USB hidraw
      KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
      # DualShock 4 over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
      # DualShock 4 Slim over bluetooth hidraw
      KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
    '';
  };
}
