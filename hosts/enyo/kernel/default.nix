{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) filter;
  inherit (lib.strings) hasSuffix;
  inherit (lib.filesystem) listFilesRecursive;

  # Get hostname from meta module.
  inherit (config.meta) hostname;

  # Call the custom Xanmod package. Any future kernel builds from different sources
  # should be added in the packages directory.
  inherit (pkgs.callPackage ./packages/xanmod.nix {inherit hostname;}) xanmod_custom;
in {
  # Autodiscover Nix files containing patch configurations
  # with patchfiles or extraStructuredConfig. This is not the
  # most optimized way to do it, but it works.
  imports = filter (hasSuffix ".nix") (listFilesRecursive ./config);
  config.modules.system.boot.kernel = pkgs.linuxPackagesFor xanmod_custom;
}
