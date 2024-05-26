{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) self;
  inherit (lib.modules) mkIf;

  # mkAgenixSecret is an abstraction around agenix secret files
  # that allows us to enable secrets conditionally, and dynamically
  # while also propagating secure defaults. Unless explicitly
  # overridden, the secret will be owned by root, and have mode 400.
  # The file argument is mandatory, and should be relative to
  # ${self}/secrets to find the secret.
  mkAgenixSecret = enableCondition: {
    file,
    owner ? "root",
    group ? "root",
    mode ? "400",
  }:
    mkIf enableCondition {
      file = "${self}/secrets/${file}";
      inherit group owner mode;
    };
in {
  inherit mkAgenixSecret;
}
