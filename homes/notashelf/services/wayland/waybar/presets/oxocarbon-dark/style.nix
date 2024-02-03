{colors}:
with colors; let
  OSLogo = builtins.fetchurl rec {
    name = "OSLogo-${sha256}.png";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
  };
in ''
  * {
    font-family: Material Design Icons, Iosevka Nerd Font Mono;
    font-size: 19px;
    border-radius: 12px;
  }

  window#waybar {
    background-color: #${base00};
    border: .5px solid #${base01};
    border-radius: 14px;
    box-shadow: 2 3 2 2px #151515;
    color: #${base05};
    margin: 16px 16px;
    transition-property: background-color;
    transition-duration: .5s;
  }

  window#waybar.hidden {
    opacity: 0.2;
  }

  #clock,
  #network,
  #custom-power,
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
  #custom-swallow,
  #volume,
  #bluetooth,
  #gamemode,
  #pulseaudio {
    border-radius: 14px;
    margin: 0px 7px 0px 7px;
    background-color: #${base01};
    padding: 10px 0px 10px 0px;
  }

  #workspaces {
    font-size: 14px;
    background-color: #${base01};
  }

  #workspaces button {
    background-color: transparent;
    border-radius: 14px;
    color: #${base04};
    font-size: 21px;
    /* Use box-shadow instead of border so the text isn't offset */
    box-shadow: inset 0 -3px transparent;
  }

  #workspaces button:hover {
    color: #${base0C};
    box-shadow: inherit;
    text-shadow: inherit;
  }

  #workspaces button.active {
    color: #${base0A};
  }

  #workspaces button.urgent {
    color: #${base08};
  }

  #network {
    /* prevents the network icon from being too squashed */
    padding: 14px 0px 14px 0px;
  }

  #cpu {
    color: rgba(0, 0, 0, 0.0);
    background-color: rgba(0, 0, 0, 0.0);
    margin: -50;
    border-radius: 16px;
  }

  #cpu.50 {
    color: #${base06};
    background-color: #${base02};
    border-radius: 15px;
    margin: 0px 7px 0px 7px;
    padding: 10px 0px 10px 0px;
  }

  #cpu.60 {
    color: #${base09};
    background-color: #${base02};
    border-radius: 15px;
    margin: 0px 7px 0px 7px;
    padding: 10px 0px 10px 0px;
  }

  #cpu.70 {
    color: #${base08};
    background-color: #${base02};
    border-radius: 15px;
    margin: 0px 7px 0px 7px;
    padding: 10px 0px 10px 0px;
  }

  #bluetooth.off,
  #bluetooth.pairable,
  #bluetooth.discovering,
  #bluetooth.disabled {
    color: rgba(0, 0, 0, 0.0);
    background-color: rgba(0, 0, 0, 0.0);
    margin: -50;
    border-radius: 16px;
  }

  #clock {
    color: #${base05};
    background-color: #${base01};
    font-weight: 700;
    font-size: 20px;
    padding: 5px 0px 5px 0px;
    font-family: "Iosevka Term";
  }

  #pulseaudio {
    padding: 5px 0px 5px 0px;
    font-size: 30;
  }

  #pulseaudio.source-muted,
  #pulseaudio.muted {
    color: #${base08};
    padding: 16px 0px 16px 0px;
    font-size: 15;
  }

  #custom-swallow {
    padding: 14px 0px 14px 0px;
  }

  #custom-todo {
    padding-left: 2px;
    background-color: #${base01};
  }

  #custom-power {
    margin-bottom: 7px;
    padding: 14px 0px 14px 0px;
  }

  #custom-search {
    background-image: url("${OSLogo}");
    background-size: 65%;
    background-position: center;
    background-repeat: no-repeat;
    margin-top: 7px;
  }

  #custom-power {
    margin-bottom: 7px;
    padding: 14px 0px 14px 0px;
    color: #${base0A};
  }

  #battery {
    border-radius: 14px;
  }

  #battery.warning {
    color: #${base09};
  }

  #battery.critical:not(.charging) {
    color: #${base08};
  }

  tooltip {
    font-family: 'Lato', sans-serif;
    border-radius: 14px;
    padding: 20px;
    margin: 30px;
  }

  tooltip label {
    font-family: 'Lato', sans-serif;
    padding: 20px;
  }

''
