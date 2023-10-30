{lib, ...}: let
  inherit (lib) mkRemovedOptionModule;
in {
  imports = [
    (mkRemovedOptionModule ["modules" "services" "override"] "test")
  ];
}
