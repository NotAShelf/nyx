{
  config,
  lib,
  ...
}: {
  services.getty.helpLine = "The 'root' account has an empty password.";

  isoImage.isoBaseName = lib.mkForce config.networking.hostName;
}
