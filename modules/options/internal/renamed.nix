{lib, ...}: let
  inherit (lib) mkRenamedOptionModule;
in {
  imports = [
    # renamed modules for the device module
    (mkRenamedOptionModule ["modules" "device" "yubikeySupport"] ["modules" "system" "yubikeySupport"])

    # renamed modules for the userEnv module
    (mkRenamedOptionModule ["modules" "usrEnv" "autologin"] ["modules" "system" "autoLogin"])
    (mkRenamedOptionModule ["modules" "usrEnv" "isWayland"] ["meta" "isWayland"])

    # renamed options for the system module
    (mkRenamedOptionModule ["modules" "system" "networking" "wirelessBackend"] ["modules" "system" "networking" "wireless" "backend"])
    (mkRenamedOptionModule ["modules" "system" "networking" "useTailscale"] ["modules" "system" "networking" "tailscale" "client" "enable"])
    (mkRenamedOptionModule ["modules" "system" "networking" "tailscale" "defaultFlags"] ["modules" "system" "networking" "tailscale" "flags" "default"])
    (mkRenamedOptionModule ["modules" "system" "networking" "tailscale" "client" "enable"] ["modules" "system" "networking" "tailscale" "isClient"])
    (mkRenamedOptionModule ["modules" "system" "networking" "tailscale" "server" "enable"] ["modules" "system" "networking" "tailscale" "isServer"])

    (mkRenamedOptionModule ["modules" "system" "services" "atticd" "enable"] ["modules" "system" "services" "bincache" "atticd" "enable"])
    (mkRenamedOptionModule ["modules" "system" "services" "wireguard" "enable"] ["modules" "system" "services" "networking" "wireguard" "enable"])
    (mkRenamedOptionModule ["modules" "system" "services" "headscale" "enable"] ["modules" "system" "services" "networking" "headscale" "enable"])

    (mkRenamedOptionModule ["modules" "system" "boot" "enableInitrdTweaks"] ["modules" "system" "boot" "initrd" "enableTweaks"])
    (mkRenamedOptionModule ["modules" "system" "security" "secureBoot"] ["modules" "system" "boot" "secureBoot"])

    (mkRenamedOptionModule ["modules" "system" "services" "gitea" "enable"] ["modules" "system" "services" "forgejo" "enable"])
    (mkRenamedOptionModule ["modules" "system" "services" "mastodon" "enable"] ["modules" "system" "services" "social" "mastodon" "enable"])
    (mkRenamedOptionModule ["modules" "system" "services" "matrix" "enable"] ["modules" "system" "services" "social" "matrix" "enable"])
  ];
}
