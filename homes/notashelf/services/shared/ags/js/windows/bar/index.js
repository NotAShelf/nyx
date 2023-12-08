import { Widget } from "../../imports.js";
const { Window, Box, CenterBox } = Widget;

// Widgets
import { launcherIcon } from "./launcher.js";
import { Workspaces } from "./workspaces.js";
import { Tray } from "./tray.js";
import { BatteryWidget } from "./battery.js";
import { Clock } from "./clock.js";
import { PowerMenu } from "./power.js";
import { Swallow } from "./swallow.js";
import { BluetoothWidget } from "./bluetooth.js";
import { AudioWidget } from "./audio.js";
import { NetworkWidget } from "./network.js";
import { SystemUsage } from "./system.js";
import { Weather } from "./weather.js";

const Top = () =>
    Box({
        className: "barTop",
        vertical: true,
        vpack: "start",
        children: [
            launcherIcon(),
            Box({
                className: "SystemUsage",
                vertical: true,
                children: [SystemUsage()],
            }),
            // Weather(),
        ],
    });

const Center = () =>
    Box({
        className: "barCenter",
        vertical: true,
        children: [Workspaces()],
    });

const Bottom = () =>
    Box({
        className: "barBottom",
        vertical: true,
        vpack: "end",
        children: [
            Tray(),
            Box({
                className: "utilsBox",
                vertical: true,
                children: [
                    BluetoothWidget(),
                    AudioWidget(),
                    Swallow(),
                    NetworkWidget(),
                    BatteryWidget(),
                ],
            }),
            Clock(),
            PowerMenu(),
        ],
    });

export const Bar = ({ monitor } = {}) =>
    Window({
        name: "bar",
        anchor: ["top", "bottom", "left"],
        exclusivity: "exclusive",
        layer: "top",
        margins: [11, 0, 11, 11],
        monitor,
        child: CenterBox({
            className: "bar",
            vertical: true,
            startWidget: Top(),
            centerWidget: Center(),
            endWidget: Bottom(),
        }),
    });
