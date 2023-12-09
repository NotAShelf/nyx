import { Widget, Utils, App, Mpris } from "../../imports.js";
const { Box, EventBox, Label, MenuItem, Menu } = Widget;
const { exec, execAsync } = Utils;

function ItemWithIcon(icon, itemLabel, onClick) {
    return MenuItem({
        className: "desktopMenuItem",
        child: Box({
            children: [
                Label({
                    className: "desktopMenuItemIcon",
                    label: icon,
                }),
                Label(itemLabel),
            ],
        }),
        onActivate: onClick,
    });
}

const Separator = () =>
    MenuItem({
        child: Box({
            className: "separator",
            css: `
            min-height: 1px;
            margin: 3px 6px;
        `,
        }),
    });

const rioMenu = () => {
    return [
        ItemWithIcon("󰆍", "Terminal", () =>
            exec(
                "sh -c \"$HOME/.config/ags/js/scripts/open_window `slurp -d -c 999999 -w 2` foot\"",
            ),
        ),
        ItemWithIcon("󰘖", "Resize", () =>
            exec(
                "sh -c \"$HOME/.config/ags/js/scripts/move_window `slurp -d -c 999999 -w 2`\"",
            ),
        ),
        ItemWithIcon("󰁁", "Move", () => exec("hyprctl dispatch submap move")),
        ItemWithIcon("󰅖", "Delete", () => exec("hyprctl kill")),
        Separator(),
    ];
};

const Powermenu = () => {
    return MenuItem({
        className: "desktopMenuItem",
        child: Box({
            children: [
                Label({
                    className: "desktopMenuItemIcon",
                    label: "󰐥",
                }),
                Label("Powermenu"),
            ],
        }),
        submenu: Menu({
            className: "desktopMenu",
            children: [
                ItemWithIcon("󰍁", "Lock", () => Utils.exec("gtklock")),
                ItemWithIcon("󰍃", "Log Out", () =>
                    exec("hyprctl dispatch exit"),
                ),
                ItemWithIcon("󰖔", "Suspend", () => exec("systemctl suspend")),
                ItemWithIcon("󰜉", "Reboot", () => exec("systemctl reboot")),
                ItemWithIcon("󰐥", "Shutdown", () => exec("systemctl poweroff")),
            ],
        }),
    });
};

export const DesktopMenu = () =>
    EventBox({
        onSecondaryClick: (_, event) =>
            Menu({
                className: "desktopMenu",
                children: [
                    ...rioMenu(),
                    ItemWithIcon("󰈊", "Colorpicker", () =>
                        execAsync(["hyprpicker", "-a", "wl-copy"]),
                    ),
                    Separator(),
                    ...(() => {
                        return Mpris.players[0]
                            ? [
                                ItemWithIcon("󰝚", "Music", () =>
                                    App.toggleWindow("music"),
                                ),
                                Separator(),
                            ]
                            : [];
                    })(),
                    Powermenu(),
                ],
            }).popup_at_pointer(event),
    });
