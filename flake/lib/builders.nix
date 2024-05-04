{
  inputs,
  lib,
  ...
}: let
  # inherit self from inputs
  inherit (inputs) self nixpkgs;
  inherit (lib.lists) singleton concatLists;
  inherit (lib.modules) mkDefault;
  inherit (lib.attrsets) recursiveUpdate;

  # shorthand alias to `lib.nixosSystem`
  # `lib.nixosSystem` is a shallow wrapper around `lib.evalModules` that passes
  # a few specialArgs and modules to bootstrap a working NixOS system. This is
  # done implicitly in the wrapper and normally we would like to avoid using it
  # however using `evalModules` to evaluate a system closure breaks e.g. the
  # `documentation.nixos.enable` option which evaluates the module tree internally
  # in which case `baseModules` will be missing
  mkSystem = lib.nixosSystem;

  # global module path for nixos modules
  # while using nixosSystem, this will be set as a specialArgs internally
  modulesPath = "${nixpkgs}/nixos/modules";

  # mkNixosSystem is a convenient wrapper around lib.nixosSystem (which itself is a wrapper around lib.evalModules)
  # that allows us to abstract host creation and configuration with necessary modules and specialArgs pre-defined
  # or properly overridden compared to their nixpkgs default. This allows us to swiftly bootstrap a new system
  # when (not if) a new system is added to `hosts/default.nix` with minimum lines of code rewritten each time.
  # Ultimately this defines specialArgs we need and lazily merges any args and modules the host may choose
  # to pass to the builder.
  mkNixosSystem = {
    withSystem,
    system,
    hostname,
    ...
  } @ args:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      mkSystem {
        # specialArgs
        specialArgs = recursiveUpdate {
          inherit lib modulesPath;
          inherit inputs self inputs' self';
        } (args.specialArgs or {});

        # Modules
        modules = concatLists [
          (singleton {
            networking.hostName = args.hostname;
            nixpkgs = {
              hostPlatform = mkDefault args.system;
              flake.source = nixpkgs.outPath;
            };

            # set baseModules in the place of nixos/lib/eval-config.nix's default argument
            # _module.args.baseModules = import "${modulesPath}/module-list.nix";
          })

          # if host needs additional modules, append them
          (args.modules or [])
        ];
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
      specialArgs = {inherit inputs lib self;} // args.specialArgs or {};
      modules = concatLists [
        [
          # provides options for modifying the ISO image
          "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

          # bootstrap channels with the ISO image to avoid fetching them during installation
          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

          # make sure our installer can detect and interact with all hardware that is supported in Nixpkgs
          # this loads basically every hardware related kernel module
          "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
        ]

        (singleton {
          networking.hostName = args.hostname;
          nixpkgs = {
            hostPlatform = mkDefault args.system;
            flake.source = nixpkgs.outPath;
          };
        })

        (args.modules or [])
      ];
    };

  mkRaspi4Image = {
    modules,
    system,
    ...
  } @ args:
    mkSystem {
      specialArgs = {inherit inputs lib self;} // args.specialArgs or {};
      modules = concatLists [
        # get an installer profile from nixpkgs to base the Isos off of
        [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ]

        (singleton {
          networking.hostName = args.hostname;
          nixpkgs = {
            hostPlatform = mkDefault args.system;
            flake.source = nixpkgs.outPath;
          };
        })

        (args.modules or [])
      ];
    };
in {
  inherit mkSystem mkNixosSystem mkNixosIso;

  mkSDImage = lib.warn "mkSDImage is deprecated, use mkRaspi4Image instead" mkRaspi4Image;
}
