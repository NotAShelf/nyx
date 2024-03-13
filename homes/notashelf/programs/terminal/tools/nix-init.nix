{pkgs, ...}: let
  toTOML = name: (pkgs.formats.toml {}).generate "${name}";
in {
  config = {
    home.packages = [pkgs.nix-init];

    xdg.configFile."nix-init/config.toml".source = toTOML "config.toml" {
      commit = true;
      maintainers = ["NotAShelf"];
    };
  };
}
