{lib, ...}: let
  inherit (lib) mkRenamedOptionModule;
in {
  imports = [
    # renamed modules for the device module
    (mkRenamedOptionModule ["modules" "device" "yubikeySupport"] ["modules" "system" "yubikeySupport"])

    # renamed modules for the userEnv module
    (mkRenamedOptionModule ["modules" "usrEnv" "autologin"] ["modules" "system" "autoLogin"])

    # renamed options for the system module
    (mkRenamedOptionModule ["modules" "system" "security" "secureBoot"] ["modules" "system" "boot" "secureBoot"])
    (mkRenamedOptionModule ["modules" "system" "services" "gitea" "enable"] ["modules" "system" "services" "forgejo" "enable"])
    (mkRenamedOptionModule ["modules" "system" "networking" "useTailscale"] ["modules" "system" "networking" "tailscale" "client" "enable"])
  ];
}
