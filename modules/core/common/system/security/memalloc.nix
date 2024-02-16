{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault optionals;
in {
  # FIXME: causes a mass rebuild
  # scudo memalloc is unstable
  # environment.memoryAllocator.provider = mkDefault "scudo"; # "graphene-hardened";

  # dhcpcd broken with scudo or graphene malloc
  nixpkgs.overlays = optionals (config.environment.memoryAllocator.provider != "libc") [
    (_final: prev: {
      dhcpcd = prev.dhcpcd.override {enablePrivSep = false;};
    })
  ];
}
