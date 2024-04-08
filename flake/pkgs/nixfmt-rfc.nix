{
  inputs,
  nixfmt-rfc-style,
  ...
}:
nixfmt-rfc-style.overrideAttrs (self: let
  pname = "nixfmt-rfc";
  version = "${self.version}-${inputs.nixfmt.shortRev}";
in {
  inherit pname version;
  src = inputs.nixfmt;
})
