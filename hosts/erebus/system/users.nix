{pkgs, ...}: {
  users.users."notashelf" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    initialHashedPassword = "$6$BGWK657mkAl3QIfc$RHkH.8P/qHQJpxIqWOA4cIhOhm0xrcvDr4Xqj0xTaFUIqfW/Oond9MMXlkV4SoGbQSAc/XOcNsf5jR5Ms6nMV0";
  };
}
