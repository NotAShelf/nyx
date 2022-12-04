{...}: let
  template = import ./template.nix "nixos";
in {
  environment.sessionVariables = template.env;

  environment.etc = {
    inherit (template) pythonrc npmrc;
  };
}
