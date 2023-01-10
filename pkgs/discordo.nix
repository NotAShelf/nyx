{
  buildGoModule,
  fetchFromGitHub,
  ...
}: let
  rev = "40e2e7e6a5533c1e0bd682cb7ccadf3e5bc5eae8";
  shortRev = builtins.substring 0 8 rev;
in
  buildGoModule {
    pname = "discordo";
    version = shortRev;

    src = fetchFromGitHub {
      owner = "ayntgl";
      repo = "discordo";
      inherit rev;
      sha256 = "sha256-620PwT6RVrc3orD6Ny51kyMMdcQU5bZ1gSMJDJA7H2g=";
    };

    vendorSha256 = "sha256-XUoKEnLy88BAeUMZ19YS/vF1TksYroayQiyds5aQ3hI=";
  }
