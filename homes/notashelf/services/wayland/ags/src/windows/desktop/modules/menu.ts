import { Widget, Utils } from "../../../imports";
const { Box, EventBox, Label, MenuItem, Menu } = Widget;
const { exec, execAsync } = Utils;

/**
 * Creates a menu item with an icon.
 * @param {string} icon - The icon to display for the menu item.
 * @param {string} itemLabel - The label for the menu item.
 * @param {Function} onClick - The function to be executed when the menu item is activated.
 * @returns {Object} A menu item object with the specified icon, label, and click action.
 */
function ItemWithIcon(
    icon: string,
    itemLabel: string,
    onClick: Function,
): object {
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
            exec('sh -c "ags-open-window `slurp -d -c 999999 -w 2` foot"'),
        ),
        ItemWithIcon("󰘖", "Resize", () =>
            exec('sh -c "ags-move-window `slurp -d -c 999999 -w 2`"'),
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

const DesktopMenu = () =>
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
                    Powermenu(),
                ],
            }).popup_at_pointer(event),
    });

export default DesktopMenu;
