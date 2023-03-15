{
  runCommand,
  self,
  pkgs,
  ...
}:
runCommand "statix-run-${self.rev or "00000000"}" {} ''
  cd ${self}
  ${pkgs.statix}/bin/statix check | tee $out
''
