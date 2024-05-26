{config, ...}: {
  services.getty.greetingLine = "<<< Welcome to ${config.meta.hostname} @ ${config.system.configurationRevision} >>>";
}
