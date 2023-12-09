import { Widget, App } from "../../imports.js";
const { Button, Label } = Widget;

export const launcherIcon = () =>
    Button({
        vexpand: false,
        className: "launcherIcon",
        cursor: "pointer",
        child: Label("󱢦"),
        onClicked: () => App.toggleWindow("launcher"),
        connections: [
            [
                App,
                (self, windowName, visible) => {
                    windowName === "launcher" &&
                        (self.child.label = visible ? "󱢡" : "󱢦");
                },
                "window-toggled",
            ],
        ],
    });
