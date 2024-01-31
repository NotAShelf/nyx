import { Widget } from "../../imports.js";
const { Window, Box, CenterBox } = Widget;

// Widgets
import { LauncherIcon } from "./modules/launcher.js";
import { Workspaces } from "./modules/workspaces.js";
import { Tray } from "./modules/tray.js";
import { BatteryWidget } from "./modules/battery.js";
import { Clock } from "./modules/clock.js";
import { PowerMenu } from "./modules/power.js";
import { Swallow } from "./modules/swallow.js";
import { BluetoothWidget } from "./modules/bluetooth.js";
import { AudioWidget } from "./modules/audio.js";
import { NetworkWidget } from "./modules/network.js";
import { SystemUsage } from "./modules/system.js";
import { Weather } from "./modules/weather.js";

const Top = () =>
    Box({
        className: "barTop",
        vertical: true,
        vpack: "start",
        children: [LauncherIcon(), SystemUsage(), Weather()],
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
                    BatteryWidget(),
                    NetworkWidget(),
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
        margins: [8, 0, 8, 8],
        monitor,
        child: CenterBox({
            className: "bar",
            vertical: true,
            startWidget: Top(),
            centerWidget: Center(),
            endWidget: Bottom(),
        }),
    });
