{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.modules.device.yubikeySupport.enable {
    hardware.gpgSmartcards.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # Yubico's official tools
      yubikey-manager
      yubikey-manager-qt
      yubikey-personalization
      yubikey-personalization-gui
      yubico-piv-tool
      yubioath-flutter
    ];
  };
}
