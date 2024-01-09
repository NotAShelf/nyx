{lib, ...}: let
  inherit (lib) mkRemovedOptionModule;
in {
  imports = [
    (mkRemovedOptionModule ["modules" "services" "override"] ''
      service overrides have been removed in favor of the new services.<name>.enable syntax
    '')
  ];
}
