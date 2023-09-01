{lib, ...}: let
  inherit (lib) mkRenamedOptionModule;
in {
  imports = [
    (mkRenamedOptionModule ["modules" "device" "yubikeySupport"] ["modules" "system" "yubikeySupport"])
    (mkRenamedOptionModule ["modules" "system" "security" "secureBoot"] ["modules" "system" "boot" "secureBoot"])
  ];
}
