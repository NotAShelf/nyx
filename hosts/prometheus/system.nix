{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    acpi
  ];

  security.tpm2 = {
    enable = lib.mkDefault true;
    abrmd.enable = lib.mkDefault true;
    pkcs11.enable = lib.mkDefault true;
    tctiEnvironment.enable = lib.mkDefault true;
  };

  fileSystems = {
    "/".options = ["noatime"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
  };

  services.btrfs.autoScrub.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };
}
