{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  rev = "808bf3c5c134b0ac7d6b8c971b2748a315043368";
  shortRev = builtins.substring 0 8 rev;
in
  buildGoModule {
    pname = "discordo";
    version = shortRev;

    src = fetchFromGitHub {
      owner = "ayntgl";
      repo = "discordo";
      inherit rev;
      sha256 = "y3TEWwjgiTmyCSTZXN9yqM54Y89RjZZYZDO6E/fYMNs=";
    };

    vendorSha256 = "WklwvGVTjP36BAY1xY1g253iU9JsjYn/MSCFTFx0V2s=";
  }
