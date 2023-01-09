{lib, ...}: {
  services.jellyfin = {
    enable = true;
    group = "jellyfin";
    user = "jellyfin";
    openFirewall = true;
  };
}
