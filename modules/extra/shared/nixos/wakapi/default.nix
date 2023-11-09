{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStrings mapAttrsToList concatMapAttrs optionalAttrs optionalString foldl' stringLength elem substring head lowerChars toUpper isBool isList boolToString types mkIf optional mkOption mkEnableOption;

  cfg = config.services.wakapi;
  user = config.users.users.wakapi.name;
  group = config.users.groups.wakapi.name;
  configFile = pkgs.writeText "wakapi.env" (concatStrings (mapAttrsToList (name: value: "${name}=${value}\n") configEnv));

  # Convert name from camel case (e.g. disable2FARemember) to upper case snake case (e.g. DISABLE_2FA_REMEMBER).
  nameToEnvVar = name: let
    parts = builtins.split "([A-Z0-9]+)" name;
    partsToEnvVar = parts:
      foldl' (key: x: let
        last = stringLength key - 1;
      in
        if isList x
        then key + optionalString (key != "" && substring last 1 key != "_") "_" + head x
        else if key != "" && elem (substring 0 1 x) lowerChars
        then # to handle e.g. [ "disable" [ "2FAR" ] "emember" ]
          substring 0 last key + optionalString (substring (last - 1) 1 key != "_") "_" + substring last 1 key + toUpper x
        else key + toUpper x) ""
      parts;
  in
    if builtins.match "[A-Z0-9_]+" name != null
    then name
    else partsToEnvVar parts;

  # Due to the different naming schemes allowed for config keys,
  # we can only check for values consistently after converting them to their corresponding environment variable name.
  configEnv = let
    configEnv = concatMapAttrs (name: value:
      optionalAttrs (value != null) {
        ${nameToEnvVar name} =
          if isBool value
          then boolToString value
          else toString value;
      })
    cfg.config;
  in
    configEnv;
in {
  options.services.wakapi = with types; {
    enable = mkEnableOption "wakapi";

    package = mkOption {
      type = package;
      default = pkgs.wakapi;
      defaultText = literalExpression "pkgs.wakapi";
      description = "wakapi package to use.";
    };

    stateDirectory = mkOption {
      type = str;
      default = "wakapi";
      defaultText = literalExpression "wakapi";
      description = "The state directory for the systemd service. Will be located in /var/lib";
    };

    config = mkOption {
      type = attrsOf (nullOr (oneOf [bool int str]));
      default = {
        config = {};
      };
      example = literalExpression ''
        {
          WAKAPI_LISTEN_IPV4=127.0.0.1
          WAKAPI_LISTEN_IPV6=::1
          WAKAPI_PORT=3000
        }
      '';
      description = ''
        The configuration of wakatime is done through environment variables,
        therefore it is recommended to use upper snake case (e.g. {env}`WAKAPI_DATA_CLEANUP_TIME`).

        However, camel case (e.g. `wakapiDataCleanupTime`) is also supported:
        The NixOS module will convert it automatically to
        upper case snake case (e.g. {env}`WAKAPI_DATA_CLEANUP_TIME`).
        In this conversion digits (0-9) are handled just like upper case characters,
        so `foo2` would be converted to {env}`FOO_2`.
        Names already in this format remain unchanged, so `FOO2` remains `FOO2` if passed as such,
        even though `foo2` would have been converted to {env}`FOO_2`.
        This allows working around any potential future conflicting naming conventions.

        Based on the attributes passed to this config option an environment file will be generated
        that is passed to wakapi's systemd service.

        The available configuration options can be found in
        [self-hostiing guide](https://github.com/muety/wakapi#-configuration-options) to
        find about the environment variables you can use.
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/wakapi.env";
      description = ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Sensitive secrets such as {env}`WAKAPI_PASSWORD_SALT` and {env}`WAKAPI_DB_PASSWORD`
        may be passed to the service while avoiding potentially making them world-readable in the nix store or
        to convert an existing non-nix installation with minimum hassle.

        Note that this file needs to be available on the host on which
        `wakapi` is running.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.wakapi = {
      inherit group;
      isSystemUser = true;
    };
    users.groups.wakapi = {};

    systemd.services.wakapi = {
      after = ["network.target"];
      #path = with pkgs; [openssl];
      serviceConfig = {
        User = user;
        Group = group;
        EnvironmentFile = [configFile] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/wakapi";
        LimitNOFILE = "1048576";
        PrivateTmp = "true";
        PrivateDevices = "true";
        ProtectHome = "true";
        ProtectSystem = "strict";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        StateDirectory = "${cfg.stateDirectory}";
        WorkingDirectory = "/var/lib/${cfg.stateDirectory}";
        StateDirectoryMode = "0700";
        Restart = "always";
      };
      wantedBy = ["multi-user.target"];
    };
    systemd.tmpfiles.rules = [
      "D /var/lib/${cfg.stateDirectory}/data 755 ${user} ${group} - -"
    ];
  };
}
