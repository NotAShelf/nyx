{
  lib,
  inputs,
  ...
}: let
  # inherit self from inputs
  inherit (inputs) self;

  # just an alias to nixpkgs.lib.nixosSystem, lets me avoid adding
  # nixpkgs to the scope in the file it is used in
  mkSystem = lib.nixosSystem;

  # mkNixoSystem is a convenient wrapper that wraps lib.nixosSystem (aliased to mkSystem here) to
  # provide us a convenient boostrapper for new systems with inputs' and self' (alongside other specialArgs)
  # already passed to the nixosSystem attribute set without us having to re-define them everytime, instead
  # defining specialArgs by default and lazily merging any additional arguments defined by the host in the builder
  mkNixosSystem = {
    modules,
    system,
    hostname,
    withSystem,
    ...
  } @ args:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      mkSystem {
        inherit system;
        specialArgs = {inherit lib inputs self inputs' self';} // args.specialArgs or {};
        modules = [{config.networking.hostName = args.hostname;}] ++ args.modules or [];
      });

  # mkIso is should be a set that extends mkSystem with necessary modules
  # to create an Iso image
  # we do not use mkNixosSystem because it overcomplicates things, an ISO does not require what we get in return for those complications
  mkNixosIso = {
    modules,
    system,
    hostname,
    ...
  } @ args:
    mkSystem {
      inherit system;
      specialArgs = {inherit inputs lib self;} // args.specialArgs or {};
      modules =
        [
          # get an installer profile from nixpkgs to base the Isos off of
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

          {config.networking.hostName = args.hostname;}
        ]
        ++ args.modules or [];
    };

  mkSdImage = {
    modules,
    system,
    ...
  } @ args:
    mkSystem {
      inherit system;
      specialArgs = {inherit inputs lib self;} // args.specialArgs or {};
      modules =
        [
          # get an installer profile from nixpkgs to base the Isos off of
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ]
        ++ args.modules or [];
    };
in {
  inherit mkSystem mkNixosSystem mkNixosIso mkSdImage;
}
