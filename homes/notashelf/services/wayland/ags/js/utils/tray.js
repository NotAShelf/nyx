import { Widget, SystemTray } from "../imports.js";
const { Button, Icon } = Widget;

export const getTrayItems = (self) => {
    self.children = SystemTray.items.map((item) =>
        Button({
            className: "trayIcon",
            child: Icon({
                setup: (self) => self.bind("icon", item, "icon"),
            }),
            setup: (self) =>
                self.bind("tooltip-markup", item, "tooltip-markup"),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
        }),
    );
};
