import { Widget, SystemTray } from "../imports";
const { Button, Icon } = Widget;

export const getTrayItems = (self: { children: any }) => {
    self.children = SystemTray.items.map((item) => {
        if (item.menu) item.menu.class_name = "trayMenu";

        return Button({
            className: "trayIcon",
            child: Icon({
                setup: (self) => self.bind("icon", item, "icon"),
            }),
            setup: (self: {
                bind: (arg0: string, arg1: any, arg2: string) => any;
            }) => self.bind("tooltip-markup", item, "tooltip-markup"),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
        });
    });
};
