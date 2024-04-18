{
  self,
  config,
  pkgs,
  lib,
  ...
}: {
  users.motd = let
    exec = package: program: "${package}/bin/${program}";
    util = exec pkgs.coreutils;
    uptime = exec pkgs.procps "uptime";
    grep = exec pkgs.gnugrep "grep";
    countUsers = ''${util "who"} -q | ${util "head"} -n1 | ${util "tr"} ' ' \\n | ${util "uniq"} | ${util "wc"} -l'';
    countSessions = ''${util "who"} -q | ${util "head"} -n1 | ${util "wc"} -w'';
  in ''
    (

    # Get the common color codes from lib
    ${toString lib.common.shellColors}

    # Color accent to use in any primary text
    CA=$PURPLE
    CAB=$BPURPLE

    echo
    echo -e " █ ''${BWHITE}Welcome back.''${CO}"
    echo    " █"
    echo -e " █ ''${BWHITE}Hostname......:''${CAB} ${config.networking.hostName}''${CO}"
    echo -e " █ ''${BWHITE}OS Version....:''${CO} NixOS ''${CAB}${config.system.nixos.version}''${CO}"
    echo -e " █ ''${BWHITE}Configuration.:''${CO} ''${CAB}${self.rev or "\${BRED}(✘ )\${CO}\${BWHITE} Dirty"}''${CO}"
    echo -e " █ ''${BWHITE}Uptime........:''${CO} $(${uptime} -p | ${util "cut"} -d ' ' -f2- | GREP_COLORS='mt=01;35' ${grep} --color=always '[0-9]*')"
    echo -e " █ ''${BWHITE}SSH Logins....:''${CO} There are currently ''${CAB}$(${countUsers})''${CO} users logged in on ''${CAB}$(${countSessions})''${CO} sessions"
    echo
    )
  '';
}
