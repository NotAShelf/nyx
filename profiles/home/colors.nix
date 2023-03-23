{lib, ...}:
with lib; {
  config = {
    modules = {
      # style module that provides a color profile
      style = {
        colorscheme = mkOption {
          type = types.str;
          default = "catppuccin-mocha";
          description = "The colorscheme that should be used globally to theme your system.";
        };
      };
    };
  };
}
