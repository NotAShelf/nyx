import { Widget } from "../../imports.js";
const { Window } = Widget;

import { DesktopMenu } from "./desktopMenu.js";
import { DesktopIcons } from "./desktopIcons.js";

export const Desktop = ({ monitor } = {}) =>
    Window({
        name: "desktop",
        anchor: ["top", "bottom", "left", "right"],
        layer: "bottom",
        monitor,
        child: Widget.Overlay({
            child: DesktopMenu(),
            overlays: [DesktopIcons()],
        }),
    });
