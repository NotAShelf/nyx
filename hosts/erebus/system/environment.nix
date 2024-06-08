{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      # Yubikey tooling
      yubikey-personalization
      cryptsetup
      pwgen
      paperkey
      gnupg
      ctmg

      # GUI tools
      konsole # KDE's terminal emulator, surprisingly good
    ];

    # needed for i3blocks
    pathsToLink = ["/libexec"];

    # fix an annoying warning
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';
  };
}
