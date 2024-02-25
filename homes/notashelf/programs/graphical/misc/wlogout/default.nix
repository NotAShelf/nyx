{pkgs, ...}: {
  xdg.configFile = {
    "wlogout/layout".text = ''
      {
        "label" : "lock",
        "action" : "loginctl lock-session",
        "text" : "Lock",
        "keybind" : "l"
      }
      {
        "label" : "hibernate",
        "action" : "systemctl hibernate",
        "text" : "Hibernate",
        "keybind" : "h"
      }
      {
        "label" : "logout",
        "action" : "loginctl terminate-user $USER",
        "text" : "Logout",
        "keybind" : "e"
      }
      {
        "label" : "shutdown",
        "action" : "systemctl poweroff",
        "text" : "Shutdown",
        "keybind" : "s"
      }
      {
        "label" : "suspend",
        "action" : "systemctl suspend",
        "text" : "Suspend",
        "keybind" : "u"
      }
      {
        "label" : "reboot",
        "action" : "systemctl reboot",
        "text" : "Reboot",
        "keybind" : "r"
      }
    '';
    "wlogout/style.css".text = let
      iconPath = "${pkgs.wlogout}/share/wlogout/icons";
    in ''
      button {
        color: @theme_text_color;
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.25);
        background-repeat: no-repeat;
        background-position: center;
        background-size: 24px;
        margin: 5px;
      }

      button:focus, button:active, button:hover {
        box-shadow: 0 0 0 1px @theme_selected_bg_color;
      }

      #lock {
        background-image: image(url("${iconPath}/lock.png"));
      }

      #logout {
        background-image: image(url("${iconPath}/logout.png"));
      }

      #suspend {
        background-image: image(url("${iconPath}/suspend.png"));
      }

      #hibernate {
        background-image: image(url("${iconPath}/hibernate.png"));
      }

      #shutdown {
       background-image: image(url("${iconPath}/shutdown.png"));
      }

      #reboot {
        background-image: image(url("${iconPath}/reboot.png"));
      }

      #firmware {
        background-image: image(url("${iconPath}/reboot.png"));
      }
    '';
  };
}
