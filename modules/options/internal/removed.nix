{lib, ...}: let
  inherit (lib) mkRemovedOptionModule;
in {
  imports = [
    (mkRemovedOptionModule ["modules" "services" "override"] ''
      service overrides have been removed in favor of the new `modules.services.<name>.enable` syntax
    '')

    (mkRemovedOptionModule ["modules" "usrEnv" "noiseSuppressor"] ''
      `modules.usrEnv.noiseSuppressor` has been removed as programs managed by the module
      are better enabled manually and individually under `modules.system.programs.<name>.enable`
    '')

    /*
    (mkRemovedOptionModule ["modules" "usrEnv" "isWayland"] ''
      `isWayland` has been moved to the meta module as a read-only option that will be set internally
      based on the desktop environments the host is running, and can no longer be set manually. Please
      move to using `modules.usrEnv.desktop` and `modules.usrEnv.desktops.<name>.enable` instead.
    '')
    */
  ];
}
