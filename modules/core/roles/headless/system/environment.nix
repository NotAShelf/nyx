{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  environment = {
    # Disable X11 libraries on headless systems to save as much space as we possibly can.
    # Settings this to true generally breaks a lot of GUI and non-GUI packages that, for
    # some reason, depend on xlibs. If this is true, said packages may also need to be
    # put into overlays. See `./nix.nix` for an example for Nginx.
    noXlibs = mkDefault false;

    # On servers, print the URL instead of trying to open them with a browser.
    variables.BROWSER = "echo";
  };
}
