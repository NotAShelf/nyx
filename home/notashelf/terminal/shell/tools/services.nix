{...}: {
  services = {
    udiskie.enable = true;

    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3"; # requires services.dbus.packages = [ pkgs.gcr ]
      enableSshSupport = true;
      defaultCacheTtl = 1209600;
      defaultCacheTtlSsh = 1209600;
      maxCacheTtl = 1209600;
      maxCacheTtlSsh = 1209600;
      extraConfig = "allow-preset-passphrase";
      enableZshIntegration = true;
    };
  };
}
