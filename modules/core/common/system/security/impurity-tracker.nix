{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;

  mkTracer = name: target: exe:
    getExe (pkgs.writeShellScriptBin name ''
      echo "PID $PPID executed ${target}" |& ${config.systemd.package}/bin/systemd-cat --identifier=impurity >/dev/null 2>/dev/null
      exec -a "$0" '${exe}' "$@"
    '');
in {
  environment = {
    usrbinenv = mkTracer "env" "/usr/bin/env" "${pkgs.coreutils}/bin/env";
    binsh = mkTracer "sh" "/bin/sh" "${pkgs.bashInteractive}/bin/sh";
  };
}
