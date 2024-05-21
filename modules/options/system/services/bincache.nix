{lib, ...}: let
  inherit (lib) mkService;
in {
  options.modules.system.services = {
    # binary cache backends
    bincache = {
      harmonia = mkService {
        name = "Harmonia";
        type = "binary cache";
        host = "[::]";
        port = 5000;
      };

      atticd = mkService {
        name = "Atticd";
        type = "binary cache";
        port = 8100;
      };
    };
  };
}
