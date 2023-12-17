{self, ...}: let
  mkFlakeModule = path:
    if builtins.isPath path
    then self + path
    else builtins.throw "${path} is not a real path! Are you stupid?";
in {
  flake = {
    # set of modules exposed by my flake to be consumed by others
    # those can be imported by adding this flake as an input and then importing the nixosModules.<moduleName>
    # i.e imports = [ inputs.nyx.nixosModules.steam-compat ]; or modules = [ inputs.nyx.nixosModules.steam-compat ];
    nixosModules = {
      # extends the steam module from nixpkgs/nixos to add a STEAM_COMPAT_TOOLS option
      # moved to nix-gaming
      # steam-compat = /modules/extra/shared/nixos/steam;

      # a module for the comma tool that wraps it with nix-index and disabled the command-not-found integration
      comma-rewrapped = mkFlakeModule /modules/extra/shared/nixos/comma;

      # an open source implementation of wakatime server
      wakapi = mkFlakeModule /modules/extra/shared/nixos/wakapi;

      # we do not want to provide a default module
      default = builtins.throw "There is no default module, sorry!";
    };

    homeManagerModules = {
      # now available in home-manager
      # xplr = mkModule /modules/extra/shared/home-manager/xplr;

      # a home-baked module for gtklock
      # allows definning extra modules and the stylesheet
      # FIXME: gtklock is currently broken thanks to the deprecation of the necessary wayland protocol
      gtklock = mkFlakeModule /modules/extra/shared/home-manager/gtklock;

      vifm = mkFlakeModule /modules/extra/shared/home-manager/vifm;

      transience = mkFlakeModule /modules/extra/shared/home-manager/transience;

      # again, we do not want to provide a default module
      default = builtins.throw "There is no default module, sorry!";
    };
  };
}
