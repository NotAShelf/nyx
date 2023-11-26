{lib, ...}: let
  template = import lib.xdgTemplate "nixos";
in {
  environment = {
    variables = template.glEnv;
    sessionVariables = template.sysEnv;
    etc = {
      inherit (template) pythonrc npmrc;
    };
  };
}
