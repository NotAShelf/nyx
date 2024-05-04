_: let
  # this is a forced SSL template for Nginx
  # returns the attribute set with our desired settings
  sslTemplate = {
    forceSSL = true;
    enableACME = true;
  };

  common = {
    shellColors = ''
      # Reset colors
      CO='\033[0m'

      # Colors
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[0;33m'
      BLUE='\033[0;34m'
      PURPLE='\033[0;35m'
      CYAN='\033[0;36m'
      WHITE='\033[0;37m'

      # Bold colors
      BBLACK='\033[1;30m'
      BRED='\033[1;31m'
      BGREEN='\033[1;32m'
      BYELLOW='\033[1;33m'
      BBLUE='\033[1;34m'
      BPURPLE='\033[1;35m'
      BCYAN='\033[1;36m'
      BWHITE='\033[1;37m'
    '';
  };
in {
  inherit sslTemplate common;
}
