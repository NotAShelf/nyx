{colorscheme}:
with colorscheme.colors; let
  OSLogo = builtins.fetchurl rec {
    name = "OSLogo-${sha256}.png";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
  };
in ''
  * {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: Material Design Icons, Iosevka Nerd Font;
  }

  window#waybar {
    background-color: #${base00};
    border: 1px solid #${base00};
    border-radius: 20px;
    color: #${base05};
    font-size: 20px;
    margin: 16px 16px;
    transition-property: background-color;
    transition-duration: .5s;
  }

  window#waybar.hidden {
    opacity: 0.2;
  }

  #workspaces {
    font-size: 15px;
    background-color: #${base02};
  }

  #pulseaudio {
    color: #${base0B};
  }

  #network {
    color: #${base0D};
  }

  gamemode {
    color: #${base0D};
    padding-right: 3px;
  }

  #custom-search,
  #custom-weather,

  #bluetooth {
    color: #${base0E};
    padding: 3px;
  }

  #clock {
    color: #${base05};
    background-color: #${base02};
  }

  #workspaces button {
    background-color: transparent;
    /* Use box-shadow instead of border so the text isn't offset */
    color: #${base0D};
    font-size: 21px;
    /* padding-left: 6px; */
    box-shadow: inset 0 -3px transparent;
  }

  #workspaces button:hover {
    color: #${base0C};
    box-shadow: inherit;
    text-shadow: inherit;
  }

  #custom-power {
      color: #${base08};
  }

  #workspaces button.active {
    color: #${base0A};
  }

  #workspaces button.urgent {
    background-color: #${base08};
  }
  #custom-weather,

  #clock,
  #network,
  #custom-swallow,
  #cpu,
  #battery,
  #backlight,
  #memory,
  #workspaces,
  #custom-search,
  #custom-power,
  #custom-todo,
  #custom-lock,
  #custom-weather,
  #volume,
  #bluetooth,
  #gamemode,
  #pulseaudio {
    border-radius: 15px;
    margin: 0px 7px 0px 7px;
    background-color: #${base02};
    padding: 10px 0px 10px 0px;
  }

  #custom-swallow {
    color: #${base0E};
    padding-right: 3px;
  }


  #custom-lock {
    color: #${base0D};
    padding-right: 1px;
  }

  #custom-todo {
    color: #${base05};
    padding-left: 2px;
  }

  #custom-power {
    margin-bottom: 7px;
  }
  #custom-search {
    background-image: url("${OSLogo}");
    background-size: 65%;
    background-position: center;
    background-repeat: no-repeat;
    margin-top: 7px;
  }
  #clock {
    font-weight: 700;
    font-size: 20px;
    padding: 5px 0px 5px 0px;
    font-family: "Iosevka Term";
  }
  #backlight {
    color: #${base0A};
  }
  #battery {
    color: #${base0C};
  }

  #battery.warning {
    color: #${base09};
  }

  #battery.critical:not(.charging) {
    color: #${base08};
  }
  tooltip {
    font-family: 'Lato', sans-serif;
    border-radius: 15px;
    padding: 20px;
    margin: 30px;
  }
  tooltip label {
    font-family: 'Lato', sans-serif;
    padding: 20px;
  }
''
