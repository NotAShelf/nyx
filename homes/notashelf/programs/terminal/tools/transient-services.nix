{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.strings) optionalString concatStringsSep;
  inherit (lib.attrsets) mapAttrsToList;

  sessionPath = optionalString (config.home.sessionPath != []) ''
    export PATH=${concatStringsSep ":" config.home.sessionPath}:$PATH
  '';

  sessionVariables = concatStringsSep "\n" (mapAttrsToList (key: value: ''
      export ${key}="${toString value}"
    '')
    config.home.sessionVariables);

  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${sessionPath}
    ${sessionVariables}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';
in {
  home.packages = [run-as-service];
}
