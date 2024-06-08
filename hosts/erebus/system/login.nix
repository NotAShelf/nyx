{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services = {
    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    gnome.gnome-keyring.enable = true;

    # Log-in automatically to a sway session.
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "notashelf";
        };
      };
    };
  };
}
