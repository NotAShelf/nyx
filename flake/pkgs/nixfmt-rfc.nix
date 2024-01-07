{
  inputs,
  nixfmt,
  ...
}: (self: _:
    nixfmt.overrideAttrs {
      pname = "nixfmt-rfc";
      src = inputs.nixfmt;
      version = "${self.version}-${inputs.nixfmt.shortRev}";
    })
