{
  runCommand,
  self,
  pkgs,
}:
runCommand "alejandra-run-${self.rev or "00000000"}" {} ''
  ${pkgs.alejandra}/bin/alejandra --check ${self} < /dev/null | tee $out
''
