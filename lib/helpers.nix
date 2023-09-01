{lib, ...}: let
  inherit (lib) lists mapAttrsToList filterAttrs hasSuffix;

  # assume the first monitor in the list of monitors is primary
  # get its name from the list of monitors
  primaryMonitor = config: builtins.elemAt config.modules.device.monitors 0;

  # filter files that have the .nix suffix
  filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

  # import files that are selected by filterNixFiles
  importNixFiles = path:
    (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  # return an int (1/0) based on boolean value
  boolToNum = bool:
    if bool
    then 1
    else 0;

  # a basic function to fetch a specified user's public keys from github .keys url
  fetchKeys = username: (builtins.fetchurl "https://github.com/${username}.keys");

  # a helper function that checks if a list contains a list of given strings
  containsStrings = {
    list,
    targetStrings,
  }:
    builtins.all (s: builtins.any (x: x == s) list) targetStrings;

  # function to generate theme slugs from theme names
  # "A String With Whitespaces" -> "a-string-with-whitespaces"
  serializeTheme = inputString: lib.strings.toLower (builtins.replaceStrings [" "] ["-"] inputString);

  # convenience function check if the declared device type is of an accepted type
  # takes config and a list of accepted device types
  # `isAcceptedDevice osConfig ["foo" "bar"];`
  isAcceptedDevice = conf: builtins.elem conf.modules.device.type;

  # assert if the device is wayland-ready by checking sys.video and env.isWayland options
  # `(lib.isWayland config)` where config is in scope
  isWayland = conf: conf.modules.system.video.enable && conf.modules.usrEnvisWayland;
in {
  inherit primaryMonitor filterNixFiles importNixFiles boolToNum fetchKeys containsStrings serializeTheme isAcceptedDevice isWayland;
}
