{
  self,
  pkgs,
  ...
}: {
  imports = [self.homeManagerModules.vifm];
  config = {
    programs.vifm = {
      enable = true;
      package = pkgs.vifm-full;
      config = builtins.readFile "${./config/vifmrc}";
      extraConfigFiles = [
        "${./config/settings/abbr.vifm}"
        "${./config/settings/commands.vifm}"
        "${./config/settings/favicons.vifm}"
        "${./config/settings/ft.vifm}"
        "${./config/settings/fv.vifm}"
        "${./config/settings/mappings.vifm}"
      ];
    };
  };
}
