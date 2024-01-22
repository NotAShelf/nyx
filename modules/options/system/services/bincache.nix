{lib, ...}: let
  inherit (lib) mkModule;
in {
  options.modules.system.services = {
    # binary cache backends
    bincache = {
      harmonia = mkModule {
        name = "Harmonia";
        type = "binary cache";
        host = "[::]";
        port = 5000;
      };

      atticd = mkModule {
        name = "Atticd";
        type = "binary cache";
        port = 8100;
      };
    };
  };
}
