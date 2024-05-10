{pkgs, ...}: {
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-v32n";
    packages = [pkgs.terminus-font];
  };

  environment = {
    shells = with pkgs; [bash zsh];
    systemPackages = with pkgs; [
      vim
      git
      killall
      bind.dnsutils
      tcpdump
      nmap
      usbutils
      wget
      direnv
      nix-direnv
      rage
      ssh-to-age
      pwgen
      w3m
    ];
  };
}
