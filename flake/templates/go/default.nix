{buildGoModule}:
buildGoModule {
  pname = "sample-go";
  version = "0.0.1";

  src = ./.;

  vendorSha256 = "";

  ldflags = ["-s" "-w"];
}
