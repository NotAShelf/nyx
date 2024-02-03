{
  inputs',
  self',
  self,
  config,
  lib,
  ...
}: let
  inherit (self) inputs;
  inherit (lib) mkIf genAttrs;
  inherit (config) modules;

  env = modules.usrEnv;
  sys = modules.system;
  defaults = sys.programs.default;
in {
  home-manager = mkIf env.useHomeManager {
    # tell home-manager to be as verbose as possible
    verbose = true;

    # use the system configuration’s pkgs argument
    # this ensures parity between nixos' pkgs and hm's pkgs
    useGlobalPkgs = true;

    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;

    # move existing files to the .old suffix rather than fa﻿iling
    # with a very long error message about it
    backupFileExtension = "old";

    # extra specialArgs passed to Home Manager
    # for reference, the config argument in nixos can be accessed
    # in home-manager through osConfig without us passing it
    extraSpecialArgs = {inherit inputs self inputs' self' defaults;};

    # per-user Home Manager configuration
    # the genAttrs function generates an attribute set of users
    # as `user = ./user` where user is picked from a list of
    # users in modules.system.users
    # the system expects user directories to be found in the present
    # directory, or will exit with directory not found errors
    users = genAttrs config.modules.system.users (name: ./${name});
  };
}
