{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  dev = config.modules.device;
in {
  config = mkIf dev.hasTPM {
    boot.kernelModules = ["uhid"];

    security.tpm2 = {
      # Enable Trusted Platform Module 2 support
      enable = true;

      applyUdevRules = true;

      # Enable Trusted Platform 2 userspace resource manager daemon
      # Setting this option to true will have TMP2 as a userspace daemon
      # and set the `security.tmp2.tssUser` that the daemon will run as.
      abrmd.enable = true;

      # The TCTI is the "Transmission Interface" that is used to communicate with a
      # TPM. this option sets TCTI environment variables to the specified values if enabled
      #  - TPM2TOOLS_TCTI
      #  - TPM2_PKCS11_TCTI
      tctiEnvironment.enable = true;

      # enable TPM2 PKCS#11 tool and shared library in system path
      pkcs11.enable = true;
    };

    # Utilities to work with TPM2 on Linux.
    environment.systemPackages = with pkgs; [tpm2-tools tpm2-tss tpm2-abrmd];
  };
}
