{lib, ...}: let
  inherit (lib) types mkOption;
in {
  options.modules.programs = {
    git = {
      signingKey = mkOption {
        type = types.str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };
  };
}
