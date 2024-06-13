{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.strings) concatStringsSep;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPaths = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
in {
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];

  services = {
    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    gnome.gnome-keyring.enable = true;

    # Log-in automatically to a sway session.
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          user = "notashelf";
          command = concatStringsSep " " [
            (getExe pkgs.greetd.tuigreet)
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--sessions '${sessionPaths}'"
          ];
        };

        initial_session = {
          user = "notashelf";
          command = "sway";
        };
      };
    };
  };

  # Suppress error messages on tuigreet. They sometimes obscure the TUI
  # boundaries of the greeter.
  # See: https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInputs = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
